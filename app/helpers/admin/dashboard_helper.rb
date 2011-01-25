module Admin

  module DashboardHelper

    def applications
      render "admin/helpers/dashboard/applications"
    end

    def resources(admin_user)
      available = Typus.resources.map do |resource|
                    resource if admin_user.resources.include?(resource)
                  end.compact
      render "admin/helpers/dashboard/resources", :resources => available
    end

  end

end
