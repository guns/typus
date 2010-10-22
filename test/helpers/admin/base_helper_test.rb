require "test_helper"

class Admin::BaseHelperTest < ActiveSupport::TestCase

  include Admin::BaseHelper

  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TextHelper

  def render(*args); args; end
  # include ActionView::Rendering
  # include ActionView::Partials

  context "header" do

    should_eventually "render with root_path" do

      # ActionView::Helpers::UrlHelper does not support strings, which are 
      # returned by named routes link root_path
      self.stubs(:link_to).returns(%(<a href="/">View site</a>))
      self.stubs(:link_to_unless_current).returns(%(<a href="/admin/dashboard">Dashboard</a>))

      output = header

      partial = "admin/helpers/header"
      options = { :links => [ %(<a href="/admin/dashboard">Dashboard</a>),
                              %(<a href="/admin/dashboard">Dashboard</a>),
                              %(<a href="/">View site</a>) ] }

      assert_equal [ partial, options ], output

    end

    should_eventually "render without root_path" do

      Rails.application.routes.named_routes.routes.reject! { |key, route| key == :root }

      self.stubs(:link_to_unless_current).returns(%(<a href="/admin/dashboard">Dashboard</a>))

      output = header
      partial = "admin/helpers/header"
      options = { :links => [ %(<a href="/admin/dashboard">Dashboard</a>),
                              %(<a href="/admin/dashboard">Dashboard</a>) ] }

      assert_equal [ partial, options ], output

    end

  end

  context "display_flash_message" do

    should "be displayed" do
      message = { :test => "This is the message." }
      output = display_flash_message(message)
      expected = ["admin/helpers/flash_message",
                  { :flash_type => :test, :message => { :test => "This is the message." } }]
      assert_equal expected, output
    end

    should "not be displayed when message is empty" do
      assert_nil display_flash_message(Hash.new)
    end

  end

end
