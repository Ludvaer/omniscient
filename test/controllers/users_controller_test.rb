require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
    assert_select "h2", "Sign Up"
    assert_select "title", "Sign Up | Omniscient"
  end

end
