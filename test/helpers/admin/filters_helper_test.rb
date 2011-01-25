require "test_helper"

class Admin::FiltersHelperTest < ActiveSupport::TestCase

  include Admin::FiltersHelper

  should "build_filters"

  should "relationship_filter"

  context "date_filter" do

    should "return an array" do
      output = date_filter("filter")
      expected = [["Show all dates", ""],
                  ["Today", "today"],
                  ["Last few days", "last_few_days"],
                  ["Last 7 days", "last_7_days"],
                  ["Last 30 days", "last_30_days"]]
      assert_equal expected, output
    end

  end

  context "boolean_filter" do

    setup do
      @resource = Post
    end

    should "return an array" do
      output = boolean_filter("filter")
      expected = [["Show by filter", ""],
                  ["True", "true"],
                  ["False", "false"]]
      assert_equal expected, output
    end

  end

  context "string_filter" do

    setup do
      @resource = Post
    end

    should "return an array" do
      output = string_filter("status")
      expected = [["Show by status", ""],
                  ["--", ""],
                  ["Unpublished", "unpublished"],
                  ["<div class=''>Something special</div>", "special"],
                  ["Draft", "draft"],
                  ["Published", "published"]]
      assert_equal expected, output
    end

    should "return an array from an ARRAY_SELECTOR" do
      output = string_filter("array_selector")
      expected = [["Show by array selector", ""],
                  ["item1", "item1"],
                  ["item2", "item2"]]
      assert_equal expected, output
    end

    should "return an array from an ARRAY_HASH_SELECTOR" do
      output = string_filter("array_hash_selector")
      expected = [["Show by array hash selector", ""],
                  ["Custom Status", "custom"],
                  ["Draft", "draft"]]
      assert_equal expected, output
    end

  end

  context "predefined_filters" do

    should "have a value" do
      expected = [["All", "index", "unscoped"]]
      assert_equal expected, predefined_filters
    end

    should "return my filter" do
      @predefined_filters = "mock"
      assert_equal "mock", predefined_filters
    end

  end

  def link_to(*args); args; end

end
