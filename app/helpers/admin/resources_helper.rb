module Admin

  module ResourcesHelper

    include FiltersHelper
    include FormHelper
    include RelationshipsHelper
    include FilePreviewHelper
    include SearchHelper
    include SidebarHelper
    include TableHelper

    #--
    # If partial `list` exists we will use it. This partial will have available
    # the `@items` so we can do whatever we want there. Notice that pagination
    # is still available.
    #++
    def build_list(model, fields, items, resource = @resource.to_resource, link_options = {}, association = nil)
      render "admin/#{resource}/list", :items => items
    rescue ActionView::MissingTemplate
      build_table(model, fields, items, link_options, association)
    end

    def display_link_to_previous
      render File.join(path, "display_link_to_previous") if params[:back_to]
    end

    private

    def path
      "admin/helpers/resources"
    end

  end

end
