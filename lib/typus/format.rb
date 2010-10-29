if RUBY_VERSION >= '1.9'
  require 'csv'
  FasterCSV = CSV
end

module Typus

  module Format

    protected

    def generate_html
      items_count = @resource.count(:joins => @joins, :conditions => @conditions)
      items_per_page = (params[:per_page] || @resource.typus_options_for(:per_page)).to_i
      @items = data.paginate(:per_page => items_per_page, :page => params[:page])
    end

    #--
    # TODO: Find in batches only works properly if it's used on models, not
    #       controllers, so in this action does nothing. We should find a way
    #       to be able to process large amounts of data.
    #++
    def generate_csv
      fields = @resource.typus_fields_for(:csv)

      filename = Rails.root.join("tmp", "export-#{@resource.to_resource}-#{Time.zone.now.to_s(:number)}.csv")

      options = { :conditions => @conditions, :batch_size => 1000 }

      FasterCSV.open(filename, 'w', :col_sep => ';') do |csv|
        csv << fields.keys
        @resource.find_in_batches(options) do |records|
          records.each do |record|
            csv << fields.map do |key, value|
                     case value
                     when :transversal
                       a, b = key.split(".")
                       record.send(a).send(b)
                     when :belongs_to
                       record.send(key).to_label
                     else
                       record.send(key)
                     end
                   end
          end
        end
      end

      send_file filename
    end

    def generate_json
      export(:json)
    end

    def generate_xml
      export(:xml)
    end

    def export(format)
      fields = @resource.typus_fields_for(format).collect { |i| i.first }
      methods = fields - @resource.column_names
      except = @resource.column_names - fields
      render format => data.send("to_#{format}", :methods => methods, :except => except)
    end

    def data
      eager_loading = @resource.reflect_on_all_associations(:belongs_to).map { |i| i.name }
      @resource.joins(@joins).where(@conditions).order(@order).includes(eager_loading)
    end

  end

end
