require "test_helper"

class Admin::BaseHelperTest < ActiveSupport::TestCase

  include Admin::BaseHelper

  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TextHelper

  def render(*args); args; end

  should_eventually "test_header_with_root_path" do

    # ActionView::Helpers::UrlHelper does not support strings, which are returned by named routes
    # link root_path
    self.stubs(:link_to).returns(%(<a href="/">View site</a>))
    self.stubs(:link_to_unless_current).returns(%(<a href="/admin/dashboard">Dashboard</a>))

    output = header

    partial = "admin/helpers/header"
    options = { :links => [ %(<a href="/admin/dashboard">Dashboard</a>),
                            %(<a href="/admin/dashboard">Dashboard</a>),
                            %(<a href="/">View site</a>) ] }

    assert_equal [ partial, options ], output

  end

  should_eventually "test_header_without_root_path" do

    Rails.application.routes.named_routes.routes.reject! { |key, route| key == :root }

    self.stubs(:link_to_unless_current).returns(%(<a href="/admin/dashboard">Dashboard</a>))

    output = header
    partial = "admin/helpers/header"
    options = { :links => [ %(<a href="/admin/dashboard">Dashboard</a>),
                            %(<a href="/admin/dashboard">Dashboard</a>) ] }

    assert_equal [ partial, options ], output

  end

  should "display_flash_message" do
    message = { :test => "This is the message." }
    output = display_flash_message(message)

    partial = "admin/helpers/flash_message"
    options = { :flash_type => :test,
                :message => { :test => "This is the message." } }

    assert_equal partial, output.first
    assert_equal options, output.last
  end

  should "not display_flash_message with empty message" do
    assert_nil display_flash_message(Hash.new)
  end

end
