require 'test_helper'

class PseudoStaticControllerTest < ActionController::TestCase
  test "should get welcome" do
    get :welcome
    assert_response :success
    assert_select "h2", "Welcome"
    assert_select "title", "Welcome | Omniscient"
    assert_select "a[href=?]", pseudo_root_path(), count: 1
    assert_select "a.btn[href=?]", signup_path(), count: 1
  end

end
