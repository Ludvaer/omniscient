#TODO: find da way test both form and js submission without reconstruction query in test code
require 'test_helper'


class UsersSignupTest < ActionDispatch::IntegrationTest


  test 'should not register invalid user' do
   	assert_no_difference 'User.count' do
    post users_path, user: { name:  "1",
                             email: "user@invalid",
                             password: "",
                             password_confirmation: "bar" }
	end
  end
end
