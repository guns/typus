module Admin

  module FiltersHelper

    def build_filters(resource = @resource)
      typus_filters = resource.typus_filters

      return if typus_filters.empty?

      filters = typus_filters.map do |key, value|
                  items = case value
                          when :boolean then boolean_filter(key)
                          when :string then string_filter(key)
                          when :date, :datetime then date_filter(key)
                          when :belongs_to then belongs_to_filter(key)
                          when :has_many, :has_and_belongs_to_many then
                            has_many_filter(key)
                          else
                            string_filter(key)
                          end

                  filter = set_filter(key, value)

        { :filter => filter, :items => items }
      end

      render "admin/helpers/filters/filters", :filters => filters
    end

    def set_filter(key, value)
      case value
      when :belongs_to
        att_assoc = @resource.reflect_on_association(key.to_sym)
        class_name = att_assoc.options[:class_name] || key.capitalize.camelize
        resource = class_name.typus_constantize
        att_assoc.primary_key_name
      else
        key
      end
    end

    def belongs_to_filter(filter)
      att_assoc = @resource.reflect_on_association(filter.to_sym)
      class_name = att_assoc.options[:class_name] || filter.capitalize.camelize
      resource = class_name.typus_constantize

      items = [[Typus::I18n.t("View belongs all %{attribute}", :attribute => @resource.human_attribute_name(filter).downcase.pluralize), ""]]
      items += [['&#151;'.html_safe, 'nil']] # HACK: allow IS NULL queries
      items += resource.order(resource.typus_order_by).map { |v| [v.to_label, v.id] }
    end

    def has_many_filter(filter)
      att_assoc = @resource.reflect_on_association(filter.to_sym)
      class_name = att_assoc.options[:class_name] || filter.classify
      resource = class_name.typus_constantize

      items = [[Typus::I18n.t("View all %{attribute}", :attribute => @resource.human_attribute_name(filter).downcase.pluralize), ""]]
      items += resource.order(resource.typus_order_by).map { |v| [v.to_label, v.id] }
    end

    def date_filter(filter)
      values = %w(today last_few_days last_7_days last_30_days)
      items = [[Typus::I18n.t("Show all dates"), ""]]
      items += values.map { |v| [Typus::I18n.t(v.humanize), v] }
    end

    def boolean_filter(filter)
      values  = @resource.typus_boolean(filter)
      items = [[Typus::I18n.t("Show by %{attribute}", :attribute => @resource.human_attribute_name(filter).downcase), ""]]
      items += values.map { |k, v| [Typus::I18n.t(k.humanize), v] }
    end

    def string_filter(filter)
      values = @resource::const_get(filter.to_s.upcase)

      items = [[Typus::I18n.t("Show by %{attribute}", :attribute => @resource.human_attribute_name(filter).downcase), ""]]

      array = case values
              when Hash
                values
              when Array
                if values.first.is_a?(Array)
                  keys, values = values.map { |i| i.first }, values.map { |i| i.last }
                  keys.to_hash_with(values)
                else
                  values.to_hash_with(values)
                end
              end

      items += array.to_a
    end

    def predefined_filters
      @predefined_filters ||= [["All", "index", "unscoped"]]
    end

  end

end
