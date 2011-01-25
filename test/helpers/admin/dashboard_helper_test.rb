require "test_helper"

class Admin::DashboardHelperTest < ActiveSupport::TestCase

  include Admin::DashboardHelper

  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TextHelper

  def render(*args); args; end

  should "render resources" do
    admin_user = Factory(:typus_user)
    output = resources(admin_user)
    expected = ["admin/helpers/dashboard/resources", { :resources => ["Git", "Status", "WatchDog"] }]
    assert_equal expected, output
  end

end
