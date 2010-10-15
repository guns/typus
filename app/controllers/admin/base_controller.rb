class Admin::BaseController < ActionController::Base

  include Typus::Authentication::const_get(Typus.authentication.to_s.classify)

  before_filter :reload_config_and_roles
  before_filter :authenticate

  helper_method :current_user

  protected

  def reload_config_and_roles
    Typus.reload! unless Rails.env.production?
  end

  def set_path
    @back_to || request.referer || admin_dashboard_path
  end

end
