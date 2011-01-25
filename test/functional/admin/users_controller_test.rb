require "test_helper"

class Admin::UsersControllerTest < ActionController::TestCase

  setup do
    @typus_user = Factory(:typus_user)
    @request.session[:typus_user_id] = @typus_user.id

    @project = Factory(:project)
    @user = @project.user
  end

  should_eventually "be able to destroy items" do
    get :destroy, { :id => @user.id, :method => :delete }

    assert_response :redirect
    assert_equal "User successfully removed.", flash[:notice]
    assert_redirected_to :action => :index
  end

  context "index" do

    should_eventually "filter by projects"

  end

end
