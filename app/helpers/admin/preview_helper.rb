module Admin

  module PreviewHelper

    def typus_preview_for_dragonfly(item, attribute)
      return unless item.send(attribute).present?

      options = { :item => item, :attribute => attribute }

      if item.send(attribute).mime_type =~ /^image\/.+/
        render "admin/helpers/preview_for_dragonfly", options
      else
        link_to item.send(attribute).name, item.send(attribute).url
      end
    end

    def typus_preview(item, attribute)
      return unless item.send(attribute).exists?

      options = { :item => item, :attribute => attribute }

      if options[:file_preview_is_image] = (item.send("#{attribute}_content_type") =~ /^image\/.+/)
        options[:has_file_preview] = item.send(attribute).styles.member?(Typus.file_preview)
        options[:has_file_thumbnail] = item.send(attribute).styles.member?(Typus.file_thumbnail)

        options[:href] = if options[:has_file_preview] && options[:file_preview_is_image]
                           item.send(attribute).url(Typus.file_preview)
                         else
                           item.send(attribute)
                         end

        options[:content] = if options[:has_file_thumbnail] && options[:file_preview_is_image]
                              image_tag item.send(attribute).url(Typus.file_thumbnail)
                            else
                              item.send(attribute)
                            end

        render "admin/helpers/preview", options
      else
        link_to item.send(attribute).original_filename, item.send(attribute).url
      end
    end

  end

end
