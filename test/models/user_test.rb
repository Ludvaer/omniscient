require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @params = {name: "Ex@mple User_001", email: "user001@example.com",
                     password: "de5fda3f485ac15bcdd72740823fa4642c5bd5ad22c8724882c1ab72ae37b6b1", 
                     password_confirmation: "de5fda3f485ac15bcdd72740823fa4642c5bd5ad22c8724882c1ab72ae37b6b1", salt: User.salt}
    @user = User.new
    @user.validate_signup_input(@params);
    @params1 = {name: "Ex@mple User_002", email: "user2@example.com",
                     password: "201c257558cf685635c225d3af5c8fcbb066cdb4c0c86f5fd9936d16e354ba11", 
                     password_confirmation: "201c257558cf685635c225d3af5c8fcbb066cdb4c0c86f5fd9936d16e354ba11", salt: User.salt}
    @user1 = User.new
    @user1.validate_signup_input(@params1);
  end

  def change_param(user,params, key,value)
    params[key] = value
    params[:salt] = User.salt
    user.validate_signup_input(params);
  end

  test "should be valid" do
    assert @user.has_name?
    assert @user.short_enough_name?
    assert @user.long_enough_name?
    assert @user.has_email?
    assert @user.short_enough_email?
    assert @user.has_email?
    assert @user.unique_name?
    assert @user.unique_email?
    assert @user.valid?
    @user.save
    assert @user.has_name?
    assert @user.short_enough_name?
    assert @user.long_enough_name?
    assert @user.has_email?
    assert @user.short_enough_email?
    assert @user.has_email?
    assert @user.unique_name?
    assert @user.unique_email?
    assert @user.valid?

  end

  test "name should be present" do
    change_param(@user,@params, :name,'         ')
    assert_not @user.valid?
    assert_not @user.has_name?
    assert @user.err
  end

  test "name should not be too long" do
    change_param(@user,@params, :name,("a" * 51))
    assert @user.err
    assert_not @user.short_enough_name?
    change_param(@user, @params, :name,("a" * 50))
    assert_not @user.err
    assert @user.short_enough_name?
  end

  test "name should not be too short" do
    change_param(@user,@params, :name,'  s       ')
    assert_not @user.valid?
    assert_not @user.long_enough_name?
    assert @user.err
    change_param(@user,@params, :name,'  ss       ')
    assert @user.valid?
    assert @user.long_enough_name?
    assert_not @user.err
  end

  test "email should be present" do
    change_param(@user, @params, :email,'         ')
    assert_not @user.valid?
    assert_not @user.has_email?
    assert @user.err
  end

  test "email should not be too long" do
    change_param(@user, @params, :email, ("a" * 200) + "@" + ("a" * 50) + "." + "aaaaa")
    assert_not @user.valid?
    assert_not @user.short_enough_email?
    assert @user.err
    change_param(@user, @params, :email, ("a" * 200) + "@" + ("a" * 50) + "." + "aaa")
    assert @user.valid?
    assert @user.short_enough_email?
    assert_not @user.err
  end


  test "user should be unique" do
    duplicate_user = @user.dup
    #@user.pseudosave
    @user.save
    assert_not duplicate_user.unique_name?
    assert_not duplicate_user.unique_email?
    #assert_not duplicate_user.valid?    
  end

  test "user email should be unique" do
    @user.save
    change_param @user1, @params1, :email, @user.email.upcase
    assert @user1.unique_name?
    assert @user1.err
    assert_not @user1.unique_email? 
    #assert_not @user1.valid?    
  end

  test "user name should be unique" do
    @user.save
    change_param @user1, @params1, :name, @user.name.upcase
    assert @user1.err
    assert_not @user1.unique_name?
    assert @user1.unique_email? 
    #assert_not @user1.valid?    
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    change_param @user, @params, :email, mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "names should be saved as lower-case" do
    mixed_case_name= "FooExAMPleName"
    change_param @user, @params, :name, mixed_case_name
    @user.name = mixed_case_name
    @user.save
    assert_equal mixed_case_name.downcase, @user.reload.downame
  end


  test "password should be present (nonblank)" do
    change_param @user, @params, :password, ""
    change_param @user, @params, :password_confirmation, ""
    #assert_not @user.valid?
    assert @user.err
    assert_not @user.has_pass?
    assert @user.password_empty
  end

  test "password should have length of 64" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
    @user.password = @user.password_confirmation = "a" * 63
    assert_not @user.valid?
    @user.password = @user.password_confirmation = "a" * 65
    assert_not @user.valid?
  end

end
