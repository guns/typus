require "test_helper"

class Admin::ResourcesHelperTest < ActiveSupport::TestCase

  include Admin::ResourcesHelper

  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper

  def render(*args); args; end

  should "verify display_link_to_previous" do
    @resource = Post
    params = { :action => "edit", :back_to => "/back_to_param" }
    self.expects(:params).at_least_once.returns(params)

    expected = [ "admin/helpers/resources/display_link_to_previous", { :message => "You're updating a Post." } ]
    output = display_link_to_previous

    assert_equal expected, output
  end

  should "remove_filter_link" do
    output = remove_filter_link("")
    assert_nil output
  end

  context "Build list" do

    setup do
      @model = TypusUser
      @fields = %w( email role status )
      @items = TypusUser.all
      @resource = "typus_users"
    end

    should "verify_build_list_when_returns_a_table" do
      expected = [ "admin/typus_users/list", { :items => [] } ]
      output = build_list(@model, @fields, @items, @resource)
      assert_equal expected, output
    end

    should "verify build_list_when_returns_a_template" do
      self.stubs(:render).returns("a_template")
      File.stubs(:exist?).returns(true)

      expected = "a_template"
      output = build_list(@model, @fields, @items, @resource)

      assert_equal expected, output
    end

  end

end
