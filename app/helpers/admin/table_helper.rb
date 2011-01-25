module Admin

  module TableHelper

    def build_table(model, fields, items, link_options = {}, association = nil, association_name = nil)
      render "admin/helpers/table/table",
             :model => model,
             :fields => fields,
             :items => items,
             :link_options => link_options,
             :headers => table_header(model, fields),
             :association_name => association_name
    end

    def table_header(model, fields, params = params)
      fields.map do |key, value|

        key = key.gsub(".", " ") if key.match(/\./)
        content = model.human_attribute_name(key)

        if params[:action].eql?('index') && model.typus_options_for(:sortable)
          association = model.reflect_on_association(key.to_sym)
          order_by = association ? association.primary_key_name : key

          if (model.model_fields.map(&:first).map { |i| i.to_s }.include?(key) || model.reflect_on_all_associations(:belongs_to).map(&:name).include?(key.to_sym))
            sort_order = case params[:sort_order]
                         when 'asc' then ['desc', '&darr;']
                         when 'desc' then ['asc', '&uarr;']
                         else [nil, nil]
                         end
            switch = sort_order.last if params[:order_by].eql?(order_by)
            options = { :order_by => order_by, :sort_order => sort_order.first }
            message = [content, switch].compact.join(" ").html_safe
            link_to message, params.merge(options)
          else
            content
          end

        else
          content
        end

      end
    end

    def table_fields_for_item(item, fields)
      fields.map { |k, v| send("table_#{v || :string}_field", k, item) }
    end

    def actions
      @actions ||= []
    end

    def table_actions(model, item, association_name = nil)
      actions.map do |action|
        if admin_user.can?(action[:action], model.name)
          link_to Typus::I18n.t(action[:action_name]),
                  { :controller => model.to_resource, :action => action[:action], :id => item.id, :resource => action[:resource], :resource_id => action[:resource_id], :association_name => association_name },
                  { :confirm => action[:confirm], :method => action[:method], :target => "_parent" }
        end
      end.compact.join(" / ").html_safe
    end

    def table_belongs_to_field(attribute, item)
      if att_value = item.send(attribute)
        action = item.send(attribute).class.typus_options_for(:default_action_on_item)
        # in place of a link, an AJAX form for changing the relationship
        if admin_user.can?(action, att_value.class.name)
          url_opts  = { :controller => "/admin/#{att_value.class.to_resource}", :action => 'update', :id => att_value.id }
          html_opts = { 'data-remote' => 'ajax-update' }
          content   = form_for item, :url => url_opts, :html => html_opts do |f|
            # memoize because this is fairly expensive
            @table_options_for_select ||= {}
            @table_options_for_select[attribute] ||= att_value.class.all.map { |r| [r.to_label, r.id] }.sort
            f.select attribute + '_id', @table_options_for_select[attribute], :selected => att_value.id, :include_blank => true
          end
        else
          att_value.to_label
        end
      else
        "&mdash;".html_safe
      end
    end

    def table_has_and_belongs_to_many_field(attribute, item)
      item.send(attribute).map { |i| i.to_label }.join(", ")
    end

    alias :table_has_many_field :table_has_and_belongs_to_many_field

    def table_string_field(attribute, item)
      (raw_content = item.send(attribute)).present? ? truncate(raw_content) : "&mdash;".html_safe
    end

    alias :table_text_field :table_string_field

    def table_generic_field(attribute, item)
      (raw_content = item.send(attribute)).present? ? raw_content : "&mdash;".html_safe
    end

    alias :table_float_field :table_generic_field
    alias :table_integer_field :table_generic_field
    alias :table_decimal_field :table_generic_field
    alias :table_virtual_field :table_generic_field

    def table_selector_field(attribute, item)
      item.mapping(attribute)
    end

    def table_file_field(attribute, item)
      typus_file_preview(item, attribute)
    end

    def table_tree_field(attribute, item)
      item.parent ? item.parent.to_label : "&mdash;".html_safe
    end

    def table_position_field(attribute, item, connector = " / ")
      url_opts  = { :controller => item.class.to_resource, :action => "position", :id => item.id }
      html_opts = { :class => 'position', 'data-remote' => 'ajax-position' }

      content_tag :div, html_opts do
        form_for(item, :url => url_opts) { |t| t.hidden_field :position }
      end
    end

    def table_datetime_field(attribute, item)
      if field = item.send(attribute)
        I18n.localize(field, :format => item.class.typus_date_format(attribute))
      end
    end

    alias :table_date_field :table_datetime_field
    alias :table_time_field :table_datetime_field

    def table_boolean_field(attribute, item)
      status = item.send(attribute)
      boolean_hash = item.class.typus_boolean(attribute).invert
      human_boolean = status ? boolean_hash["true"] : boolean_hash["false"]

      options = { :controller => "/admin/#{item.class.to_resource}",
                  :action => "toggle",
                  :id => item.id,
                  :field => attribute.gsub(/\?$/, '') }
      confirm = Typus::I18n.t("Change %{attribute}?", :attribute => item.class.human_attribute_name(attribute).downcase)
      link_to Typus::I18n.t(human_boolean), options, :confirm => confirm
    end

    def table_transversal_field(attribute, item)
      field_1, field_2 = attribute.split(".")
      obj = item.send(field_1).send(field_2)

      # FIXME: ensure attachment instance belongs to item
      # if we have an attachment at the end of the method call, link to the
      # current item's edit page, anchoring at the has_many table
      if get_type_of_attachment(obj) == :paperclip
        anchor = case obj.content_type
        when %r(\Aimage/) then image_tag obj.url(Typus.file_thumbnail)
        when nil          then nil
        else obj
        end

        if anchor
          # FIXME: this link does not work properly
          link_to anchor, "/admin/#{item.class.name.tableize}/edit/#{item.id}##{obj.instance.class.name.tableize}"
        else
          anchor
        end
      else
        obj
      end
    end

  end

end
