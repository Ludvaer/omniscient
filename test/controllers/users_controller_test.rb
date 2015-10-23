require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
    assert_select "h2", "Sign up"
    assert_select "title", "Sign up | Omniscient"
  end

end
