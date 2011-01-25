class ActiveRecord::Base

  def self.relationship_with(model)
    association = reflect_on_association(model.table_name.to_sym) ||
                  reflect_on_association(model.model_name.downcase.to_sym)
    association.macro
  end

  #--
  #     >> Post.to_resource
  #     => "posts"
  #     >> Admin::User.to_resource
  #     => "admin/users"
  #++
  def self.to_resource
    name.underscore.pluralize
  end

  #--
  # On a model:
  #
  #     class Post < ActiveRecord::Base
  #       STATUS = {  t("Published") => "published",
  #                   t("Pending") => "pending",
  #                   t("Draft") => "draft" }
  #     end
  #
  #     >> Post.first.status
  #     => "published"
  #     >> Post.first.mapping(:status)
  #     => "Published"
  #     >> I18n.locale = :es
  #     => :es
  #     >> Post.first.mapping(:status)
  #     => "Publicado"
  #++
  def mapping(attribute)
    values = self.class::const_get(attribute.to_s.upcase)

    if values.is_a?(Array)
      case values.first
      when Array
        array_keys, array_values = values.transpose
      else
        array_keys = array_values = values
      end
      values = array_keys.to_hash_with(array_values)
    end

    values.invert[send(attribute)]
  end

  def to_label
    if    respond_to? :typus_select_name  then send :typus_select_name
    elsif respond_to? :name               then send :name
    else  [self.class, id].join '#'
    end
  end

end
