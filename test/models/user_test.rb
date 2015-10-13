require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com")
  end

  test "should be valid" do
    assert @user.valid?
    assert @user.has_name?
    assert @user.short_enough_name?
    assert @user.long_enough_name?
    assert @user.has_email?
  end

  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
    assert_not @user.has_name?
  end

  test "name should not be too long" do
    @user.name = ("a" * 51)
    assert_not @user.valid?
    assert_not @user.short_enough_name?
    @user.name = ("a" * 26)
    p @user.name
    p @user.name.length
    p @user.short_enough_name?
    assert @user.valid?
    assert @user.short_enough_name?
  end

  test "name should not be too short" do
    @user.name = "a" * 1
    assert_not @user.valid?
    assert_not @user.long_enough_name?
    @user.name = "a" * 2
    assert @user.valid?
    assert @user.long_enough_name?
  end

  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
    assert_not @user.has_email?
  end

  #test "password digest should be present" do
  #  @user.email = "     "
  #  assert_not @user.valid?
  #  assert_not @user.hasPassword?
  #end
end
