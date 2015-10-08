require 'test_helper'

class PseudoStaticControllerTest < ActionController::TestCase
  test "should get welcome" do
    get :welcome
    assert_response :success
    assert_select "h1", "Welcome"
    assert_select "title", "Home | Omniscient"
  end

end
