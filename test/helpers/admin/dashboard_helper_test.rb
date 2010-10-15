require "test_helper"

class Admin::DashboardHelperTest < ActiveSupport::TestCase

  include Admin::DashboardHelper

  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TextHelper

  def render(*args); args; end

  should "render resources" do
    current_user = Factory(:typus_user)

    output = resources(current_user)
    partial = "admin/helpers/dashboard/resources"
    options = { :resources => ["Git", "Status", "WatchDog"] }

    assert_equal partial, output.first
    assert_equal options, output.last
  end

end
