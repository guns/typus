require "test_helper"

class Admin::TypusUsersControllerTest < ActionController::TestCase

  context "Admin" do

    setup do
      @typus_user = Factory(:typus_user)
      @typus_user_editor = Factory(:typus_user, :email => "editor@example.com", :role => "editor")
      @request.session[:typus_user_id] = @typus_user.id
      @request.env['HTTP_REFERER'] = '/admin/typus_users'
    end

    should "be able to render new" do
      get :new
      assert_response :success
    end

    should "not be able to toogle his status" do
      get :toggle, { :id => @typus_user.id, :field => 'status' }
      assert_response :redirect
      assert_redirected_to @request.env['HTTP_REFERER']
      assert_equal "You can't toggle your status.", flash[:notice]
    end

    should "be able to toggle other users status" do
      get :toggle, { :id => @typus_user_editor.id, :field => 'status' }
      assert_response :redirect
      assert_redirected_to @request.env['HTTP_REFERER']
      assert_equal "Typus user successfully updated.", flash[:notice]
    end

    should "not be able to destroy himself" do
      assert_raises RuntimeError do
        delete :destroy, :id => @typus_user.id
      end
    end

    should "be able to destroy other users" do
      assert_difference('TypusUser.count', -1) do
        delete :destroy, :id => @typus_user_editor.id
      end

      assert_response :redirect
      assert_redirected_to @request.env['HTTP_REFERER']
      assert_equal "Typus user successfully removed.", flash[:notice]
    end

    should "be able to update other users role" do
      post :update, { :id => @typus_user_editor.id, :typus_user => { :role => 'admin' } }
      assert_response :redirect
      assert_redirected_to "/admin/typus_users"
      assert_equal "Typus user successfully updated.", flash[:notice]
    end

  end

  context "Editor" do

    setup do
      @request.env['HTTP_REFERER'] = '/admin/typus_users'
      @editor = Factory(:typus_user, :email => "editor@example.com", :role => "editor")
      @request.session[:typus_user_id] = @editor.id
    end

    should "not_allow_editor_to_create_typus_users" do
      get :new
      assert_response :redirect
      assert_redirected_to @request.env['HTTP_REFERER']
      assert_equal "Editor is not able to perform this action. (new)", flash[:notice]
    end

    should "be able to edit his profile" do
      get :edit, { :id => @editor.id }
      assert_response :success
    end

    should "be able to update his profile" do
      post :update, { :id => @editor.id, :typus_user => { :role => 'editor' } }
      assert_response :redirect
      assert_redirected_to "/admin/typus_users"
      assert_equal "Typus user successfully updated.", flash[:notice]
    end

    should "not be able to update his profile and become root" do
      post :update, { :id => @editor.id, :typus_user => { :role => 'admin' } }
      assert_response :redirect
      assert_redirected_to @request.env['HTTP_REFERER']
      assert_equal "You can't change your role.", flash[:notice]
    end

    should "not be able to destroy his profile" do
      assert_raises RuntimeError do
        delete :destroy, :id => @editor.id
      end
    end

    should "not be able to toggle other his status" do
      assert_raises RuntimeError do
        get :toggle, { :id => @editor.id, :field => 'status' }
      end
    end

    should "not be able to edit other profiles" do
      user = Factory(:typus_user)
      assert_raises RuntimeError do
        get :edit, { :id => user.id }
      end
    end

    should_eventually "not be able to update other profiles" do
      user = Factory(:typus_user)
      assert_raises RuntimeError do
        post :update, { :id => user.id, :typus_user => { :role => 'admin' } }
      end
    end

    should "not be able to destroy other profiles" do
      user = Factory(:typus_user)
      assert_raises RuntimeError do
        delete :destroy, :id => user.id
      end
    end

    should "not be able to toggle other profiles status" do
      user = Factory(:typus_user)
      assert_raises RuntimeError do
        get :toggle, { :id => user.id, :field => 'status' }
      end
    end

  end

  ##
  # Designer doesn't have TypusUser permissions BUT can update his profile.
  #

  context "Designer" do

    setup do
      @designer = Factory(:typus_user, :email => "designer@example.com", :role => "designer")
      @request.session[:typus_user_id] = @designer.id
    end

    should "be able to edit his profile" do
      get :edit, { :id => @designer.id }
      assert_response :success
    end

    should "be able to update his profile" do
      post :update, { :id => @designer.id, :typus_user => { :role => 'designer', :email => 'designer@withafancydomain.com' } }
      assert_response :redirect
      assert_redirected_to "/admin/typus_users"
      assert_equal "Typus user successfully updated.", flash[:notice]
      assert_equal "designer@withafancydomain.com", @designer.reload.email
    end

  end

end
