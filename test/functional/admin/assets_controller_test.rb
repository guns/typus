require "test_helper"

class Admin::AssetsControllerTest < ActionController::TestCase

  setup do
    @request.session[:typus_user_id] = Factory(:typus_user).id
    @post = Factory(:post)
  end

  should "verify polymorphic relationship message" do
    get :new, { :back_to => "/admin/posts/#{@post.id}/edit",
                :resource => @post.class.name, :resource_id => @post.id }

    assert_select 'body div#flash', "You're adding a new Asset to Post. Do you want to cancel it?"
    assert_select 'body div#flash a', "Do you want to cancel it?"
  end

  should "create a polymorphic relationship" do
    assert_difference('@post.assets.count') do
      post :create, { :asset => { :caption => "Caption",
                      :file => File.new("#{Rails.root}/config/database.yml"),
                      :required_file => File.new("#{Rails.root}/config/database.yml") },
                      :back_to => "/admin/posts/edit/#{@post.id}",
                      :resource => @post.class.name, :resource_id => @post.id }
    end

    assert_response :redirect
    assert_redirected_to '/admin/posts/edit/1'
    assert_equal "Asset successfully assigned to Post.", flash[:notice]
  end

  context "edit" do

    setup do
      @asset = Factory(:asset)
      @request.env['HTTP_REFERER'] = "/admin/assets/edit/#{@asset.id}"
    end

    should "verify there is a file link" do
      get :edit, { :id => @asset.id }
      assert_match /#{@asset.file.url}/, @response.body
    end

    should "verify file can be removed" do
      get :edit, { :id => @asset.id }
      assert_match /Remove file/, @response.body

      assert @asset.file_uid.present?

      get :detach, { :id => @asset.id, :attribute => "file" }
      assert_response :redirect
      assert_redirected_to @request.env['HTTP_REFERER']
      assert_equal "Asset successfully updated.", flash[:notice]

      @asset.reload
      assert @asset.file_uid.blank?
    end

    should "verify required_file can not removed" do
      get :edit, { :id => @asset.id }
      assert_no_match /Remove required file/, @response.body

      get :detach, { :id => @asset.id, :attribute => "required_file" }
      assert_response :success

      @asset.reload
      assert @asset.file.present?
    end

    should "verify message on polymorphic relationship" do
      asset = Factory(:asset)

      get :edit, { :id => asset.id,
                   :back_to => "/admin/posts/#{@post.id}/edit",
                   :resource => @post.class.name, :resource_id => @post.id }

      assert_select 'body div#flash', "You're updating a Asset for Post. Do you want to cancel it?"
      assert_select 'body div#flash a', "Do you want to cancel it?"
    end

  end

  should "return to back_to url" do
    asset = Factory(:asset)
    back_to = "#assets"

    post :update, { :id => asset.id,
                    :back_to => back_to,
                    :resource => @post.class.name,
                    :resource_id => @post.id }

    assert_response :redirect
    assert_redirected_to :action => "edit", :id => asset.id, :back_to => back_to
    assert_equal "Asset successfully updated.", flash[:notice]
  end

end
