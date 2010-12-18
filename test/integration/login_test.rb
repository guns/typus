require 'test_helper'

class LoginTest < ActionController::IntegrationTest

  context "Admin goes to login page" do

    should_eventually "views page" do
      visit '/admin'
    end

  end

end
