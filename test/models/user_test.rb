require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com")
  end

  test "should be valid" do
    assert @user.valid?
    assert @user.hasName?
    assert @user.hasMail?
  end

  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
    assert_not @user.hasName?
  end

  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
    assert_not @user.hasEmail?
  end

  test "password digest should be present" do
    @user.email = "     "
    assert_not @user.valid?
    assert_not @user.hasPassword?
  end
end
