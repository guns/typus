module Admin

  module RelationshipsHelper

    def setup_relationship(field)
      @field = field
      @model_to_relate = @resource.reflect_on_association(field.to_sym).class_name.typus_constantize
      @model_to_relate_as_resource = @model_to_relate.to_resource
      @reflection = @resource.reflect_on_association(field.to_sym)
      @association_name = @reflection.through_reflection ? @reflection.name.to_s : @model_to_relate.model_name.tableize
    end

    def typus_form_has_many(field)
      setup_relationship(field)
      if @reflection.through_reflection
        @items_to_relate = @model_to_relate.all - @item.send(field)
      else
        @items_to_relate = @model_to_relate.where(@reflection.primary_key_name => nil) - @item.send(field)
      end

      if set_condition && @items_to_relate.any?
        form = build_relate_form
      end

      unless @reflection.through_reflection
        foreign_key = @reflection.primary_key_name
      end

      options = { foreign_key => @item.id }

      build_pagination

      render "admin/templates/has_n",
             :model_to_relate => @model_to_relate,
             :model_to_relate_as_resource => @model_to_relate_as_resource,
             :association_name => @association_name,
             :foreign_key => foreign_key,
             :add_new => build_add_new(options),
             :form => form,
             :table => build_relationship_table
    end

    def typus_form_has_and_belongs_to_many(field)
      setup_relationship(field)

      @items_to_relate = @model_to_relate.all - @item.send(field)

      if set_condition && @items_to_relate.any?
        form = build_relate_form
      end

      build_pagination

      render "admin/templates/has_n",
             :model_to_relate => @model_to_relate,
             :model_to_relate_as_resource => @model_to_relate_as_resource,
             :association_name => @association_name,
             :add_new => build_add_new,
             :form => form,
             :table => build_relationship_table
    end

    def build_pagination
      options = { :order => @model_to_relate.typus_order_by, :conditions => set_conditions }
      items_per_page = (params[:per_page] || @model_to_relate.typus_options_for(:per_page)).to_i
      data = @resource.unscoped.find(params[:id]).send(@field).all(options)
      @items = data.paginate(:per_page => items_per_page, :page => params[:page])
    end

    def build_relate_form
      render "admin/templates/relate_form",
             :model_to_relate => @model_to_relate,
             :items_to_relate => @items_to_relate,
             :association_name => @association_name
    end

    def build_relationship_table
      build_list(@model_to_relate,
                 @model_to_relate.typus_fields_for(:relationship),
                 @items,
                 @model_to_relate_as_resource,
                 {},
                 @reflection.macro,
                 @association_name)
    end

    def build_add_new(options = {})
      default_options = { :controller => "/admin/#{@model_to_relate.to_resource}", :action => "new",
                          :resource => @resource.model_name, :resource_id => @item.id,
                          :back_to => @back_to }

      if set_condition && admin_user.can?("create", @model_to_relate)
        link_to Typus::I18n.t("Add new"), default_options.merge(options)
      end
    end

    def set_condition
      if @resource.typus_user_id? && admin_user.is_not_root?
        @item.owned_by?(admin_user)
      else
        true
      end
    end

    def set_conditions
      if @model_to_relate.typus_options_for(:only_user_items) && admin_user.is_not_root?
        { Typus.user_fk => admin_user }
      end
    end

    def typus_form_has_one(field)
      setup_relationship(field)

      @items = Array.new
      if item = @resource.find(params[:id]).send(field)
        @items << item
      end

      render "admin/templates/has_one",
             :model_to_relate => @model_to_relate,
             :model_to_relate_as_resource => @model_to_relate_as_resource,
             :add_new => @items.empty? ? build_add_new : nil,
             :table => build_relationship_table
    end

    def typus_belongs_to_field(attribute, form)
      ##
      # We can only pass parameters to 'new' and 'edit'. This hack replaces
      # the current action.
      #
      params[:action] = (params[:action] == 'create') ? 'new' : params[:action]

      back_to = url_for(:controller => params[:controller], :action => params[:action], :id => params[:id])

      related = @resource.reflect_on_association(attribute.to_sym).class_name.typus_constantize
      related_fk = @resource.reflect_on_association(attribute.to_sym).primary_key_name

      if params[:action] == 'edit'
        options = { :resource => @resource.model_name,
                    :resource_id => @item.id }
      else
        options = { :resource => @resource.model_name }
      end

      default = { :controller => "/admin/#{related.to_resource}", :action => 'new', :back_to => back_to }

      if admin_user.can?('create', related)
        message = link_to Typus::I18n.t("Add"), default.merge(options)
      end

      values = related.respond_to?(:roots) ?
        expand_tree_into_select_field(related.roots, related_fk) :
        related.order(related.typus_order_by).map { |p| [p.to_label, p.id] }

      render "admin/templates/belongs_to",
             :resource => @resource,
             :attribute => attribute,
             :form => form,
             :related_fk => related_fk,
             :message => message,
             :label_text => @resource.human_attribute_name(attribute),
             :values => values,
             # :html_options => { :disabled => attribute_disabled?(attribute) },
             :html_options => {},
             :options => { :include_blank => true }
    end

  end

end
