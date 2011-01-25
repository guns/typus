require "rails/generators/migration"
require "generators/typus/controller_generator"
require "generators/typus/assets_generator"

module Typus

  module Generators

    class TypusGenerator < Rails::Generators::Base

      include Rails::Generators::Migration

      source_root File.expand_path("../../templates", __FILE__)

      namespace "typus"

      class_option :admin_title, :default => Rails.root.basename

      desc <<-DESC
Description:
  This generator creates required files to enable an admin panel which allows
  trusted users to edit structured content.

  To enable session authentication run `rails g typus:migration`.

      DESC

      def copy_config_readme
        copy_file "config/typus/README"
      end

      def generate_initializer
        template "config/initializers/typus.rb", "config/initializers/typus.rb"
        template "config/initializers/typus_resources.rb", "config/initializers/typus_resources.rb"
      end

      def copy_assets
        Typus::Generators::AssetsGenerator.new.invoke_all
      end

      def generate_controllers
        Typus.application_models.each do |model|
          Typus::Generators::ControllerGenerator.new([model.pluralize]).invoke_all
        end
      end

      def generate_config
        if (@configuration = generate_yaml_files)[:base].present?
          %w(application.yml application_roles.yml).each do |file|
            template "config/typus/#{file}", "config/typus/#{timestamp}_#{file}"
          end
        end
      end

      protected

      def configuration
        @configuration
      end

      def resource
        @resource
      end

      def sidebar
        @sidebar
      end

      def timestamp
        Time.zone.now.to_s(:number)
      end

      private

      def generate_yaml_files
        Typus.reload!

        configuration = { :base => "", :roles => "" }

        Typus.application_models.sort { |x,y| x <=> y }.each do |model|

          next if Typus.models.include?(model)

          klass = model.constantize

          # Detect all relationships except polymorphic belongs_to using reflection.
          relationships = [ :belongs_to, :has_and_belongs_to_many, :has_many, :has_one ].map do |relationship|
                            klass.reflect_on_all_associations(relationship).reject { |i| i.options[:polymorphic] }.map { |i| i.name.to_s }
                          end.flatten.sort

          ##
          # Model fields for:
          #
          # - Default
          # - Form
          #

          rejections = %w( ^id$
                           created_at created_on updated_at updated_on deleted_at
                           salt crypted_password
                           password_salt persistence_token single_access_token perishable_token
                           _type$ type
                           _file_size$ )

          default_rejections = (rejections + %w( password password_confirmation )).join("|")
          form_rejections = (rejections + %w( position )).join("|")

          fields = klass.columns.map(&:name)
          default = fields.reject { |f| f.match(default_rejections) }
          form = fields.reject { |f| f.match(form_rejections) }

          # Model defaults.
          order_by = "position" if default.include?("position")
          filters = "created_at" if fields.include?("created_at")
          search = ( %w(name title) & default ).join(", ")

          # We want attributes of belongs_to relationships to be shown in our
          # field collections if those are not polymorphic.
          [ default, form ].each do |fields|
            fields << klass.reflect_on_all_associations(:belongs_to).reject { |i| i.options[:polymorphic] }.map { |i| i.name.to_s }
            fields.flatten!
          end

          configuration[:base] << <<-RAW
#{klass}:
  fields:
    default: #{default.join(", ")}
    form: #{form.join(", ")}
  order_by: #{order_by}
  relationships: #{relationships.join(", ")}
  filters: #{filters}
  search: #{search}
  application: #{options[:admin_title]}

          RAW

          configuration[:roles] << <<-RAW
  #{klass}: create, read, update, delete
          RAW

        end

        configuration
      end

    end

  end

end
