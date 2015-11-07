#TODO: find da way test both form and js submission without reconstruction query in test code
require 'test_helper'


class UsersSignupTest < ActionDispatch::IntegrationTest


  test 'should not register invalid user' do
  	get signup_path
   	assert_no_difference 'User.count' do
    post users_path, user: { name:  "1",
                             email: "user@invalid",
                             password: "",
                             password_confirmation: "bar" }
	end
  end


    test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { name:  "Example User3",
                                            email: "user3@example.com",
                                            password:              "password3",
                                            password_confirmation: "password3" }
    end
    assert_template 'users/show'
  end

end
