#TODO: find da way test both form and js submission without reconstruction query in test code
require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
	include Capybara::DSL
	def setup
	  	Capybara.current_driver = :selenium
	  	#Capybara.app_host = "http://localhost:3000"
	  	Capybara.run_server = true #Whether start server when testing
	    Capybara.server_port = 8200
	end

#  test 'should not register invalid user' do
#  	get signup_path
#   	assert_no_difference 'User.count' do
#    post users_path, user: { name:  "1",
#                             email: "user@invalid",
#                             password: "",
#                             password_confirmation: "bar" }
#	end
  #end


  #test "valid signup information" do
  #  get signup_path
  #  assert_difference 'User.count', 1 do
  #    post_via_redirect users_path, user: { name:  "Example User3",
  #                                          email: "user3@example.com",
  #                                          password:              "password3",
  #                                          password_confirmation: "password3" }
  #  end
  #  assert_template 'users/show'
  #ends

  test 'valid user data check' do
  	visit('/signup')
  	fill_in('user[name]', :with => 'asdf1234')
  	fill_in('user[password]', :with => 'asdf1234')
  	fill_in('user[password_confirmation]', :with => 'asdf1234')
  	fill_in('user[email]', :with => 'asdf1234@asdf.asdf')
  	first("input.btn").click()
  	assert page.has_css?('p#notice', text: 'User was successfully created.')

  	visit('/signup')
  	fill_in('user[name]', :with => 'asdf1234')
  	fill_in('user[password]', :with => 'asdf1234')
  	fill_in('user[password_confirmation]', :with => 'asdf1234')
  	fill_in('user[email]', :with => '')
  	first("input.btn").click()
  	assert page.has_css?('div#name-empty', visible: false)
  	assert page.has_css?('div#name-too-short', visible: false)
  	assert page.has_css?('div#name-too-long', visible: false)
  	assert page.has_css?('div#name-invalid', visible: false)
  	assert page.has_css?('div#name-taken', visible: true)
  	assert page.has_css?('div#password-confirmation-not-match', visible: false)
  	assert page.has_css?('div#password-empty', visible: false)
  	assert page.has_css?('div#email-empty', visible: true)
  	assert page.has_css?('div#email-too-long', visible: false)
  	assert page.has_css?('div#email-invalid', visible: false)
  	assert page.has_css?('div#email-taken', visible: false)
  	assert page.has_no_css?('div#error_explanation')

  	visit('/signup')
  	fill_in('user[name]', :with => 'a')
  	fill_in('user[password]', :with => '')
  	fill_in('user[password_confirmation]', :with => 'asdf123')
  	fill_in('user[email]', :with => 'abcdefghijklmnopqrstabcdefghijklmnopqrstabcdefghijklmnopqrstabcdefghijklmnopqrstabcdefghijklmnopqrstabcdefghijklmnopqrstabcdefghijklmnopqrstabcdefghijklmnopqrstabcdefghijklmnopqrstabcdefghijklmnop@qrstabcdefghijklmnopqrstabcdefghijklmnopqrstabcdefghijklmnopqrst.asdfasdf')
  	first("input.btn").click()
  	assert page.has_css?('div#name-empty', visible: false)
  	assert page.has_css?('div#name-too-short', visible: true)
  	assert page.has_css?('div#name-too-long', visible: false)
  	assert page.has_css?('div#name-invalid', visible: false)
  	assert page.has_css?('div#name-taken', visible: false)
  	assert page.has_css?('div#password-empty', visible: true)
  	assert page.has_css?('div#password-confirmation-not-match', visible: true)
  	assert page.has_css?('div#email-empty', visible: false)
  	assert page.has_css?('div#email-too-long', visible: true)
  	assert page.has_css?('div#email-invalid', visible: false)
  	assert page.has_css?('div#email-taken', visible: false)
  	assert page.has_no_css?('div#error_explanation')

  	visit('/signup')
  	fill_in('user[name]', :with => '')
  	fill_in('user[password]', :with => 'asdf1234')
  	fill_in('user[password_confirmation]', :with => 'asdf123')
  	fill_in('user[email]', :with => 'asdf1df.asdf')
  	first("input.btn").click()
  	assert page.has_css?('div#name-empty', visible: true)
  	assert page.has_css?('div#name-too-short', visible: false)
  	assert page.has_css?('div#name-too-long', visible: false)
  	assert page.has_css?('div#name-invalid', visible: false)
  	assert page.has_css?('div#name-taken', visible: false)
  	assert page.has_css?('div#password-empty', visible: false)
  	assert page.has_css?('div#password-confirmation-not-match', visible: true)
  	assert page.has_css?('div#email-empty', visible: false)
  	assert page.has_css?('div#email-too-long', visible: false)
  	assert page.has_css?('div#email-invalid', visible: true)
  	assert page.has_css?('div#email-taken', visible: false)
    assert page.has_no_css?('div#error_explanation')

  	visit('/signup')
  	fill_in('user[name]', :with => 'abcdefghijklmnopqrstabcdefghijklmnopqrstabcdefghijklmnopqrst')
  	fill_in('user[password]', :with => '')
  	fill_in('user[password_confirmation]', :with => '')
  	fill_in('user[email]', :with => 'asdf1234@asdf.asdf')
  	first("input.btn").click()
  	assert page.has_css?('div#name-empty', visible: false)
  	assert page.has_css?('div#name-too-short', visible: false)
  	assert page.has_css?('div#name-too-long', visible: true)
  	assert page.has_css?('div#name-invalid', visible: false)
  	assert page.has_css?('div#name-taken', visible: false)
  	assert page.has_css?('div#password-empty', visible: true)
  	assert page.has_css?('div#password-confirmation-not-match', visible: false)
  	assert page.has_css?('div#email-empty', visible: false)
  	assert page.has_css?('div#email-too-long', visible: false)
  	assert page.has_css?('div#email-invalid', visible: false)
  	assert page.has_css?('div#email-taken', visible: true)
  	assert page.has_no_css?('div#error_explanation')

  	visit('/signup')
  	fill_in('user[name]', :with => '!@#$!@#$@%^$*(^)*(_*(*+')
  	fill_in('user[password]', :with => 'asdf')
  	fill_in('user[password_confirmation]', :with => 'asdf')
  	fill_in('user[email]', :with => 'asdf12345674321@asdf.asdf')
  	first("input.btn").click()  	
  	assert page.has_css?('div#name-empty', visible: false)
  	assert page.has_css?('div#name-too-short', visible: false)
  	assert page.has_css?('div#name-too-long', visible: false)
  	assert page.has_css?('div#name-invalid', visible: true)
  	assert page.has_css?('div#name-taken', visible: false)
  	assert page.has_css?('div#password-empty', visible: false)
  	assert page.has_css?('div#password-confirmation-not-match', visible: false)
  	assert page.has_css?('div#email-empty', visible: false)
  	assert page.has_css?('div#email-too-long', visible: false)
  	assert page.has_css?('div#email-invalid', visible: false)
  	assert page.has_css?('div#email-taken', visible: false)
  	assert page.has_no_css?('div#error_explanation')

  	visit('/signup')

  	assert page.has_css?('div#name-empty', visible: false)
  	assert page.has_css?('div#name-too-short', visible: false)
  	assert page.has_css?('div#name-too-long', visible: false)
  	assert page.has_css?('div#name-invalid', visible: false)
  	assert page.has_css?('div#name-taken', visible: false)
  	assert page.has_css?('div#password-empty', visible: false)
  	assert page.has_css?('div#password-confirmation-not-match', visible: false)
  	assert page.has_css?('div#email-empty', visible: false)
  	assert page.has_css?('div#email-too-long', visible: false)
  	assert page.has_css?('div#email-invalid', visible: false)
  	assert page.has_css?('div#email-taken', visible: false)
  	assert page.has_no_css?('div#error_explanation')

  	visit('/login')
  	fill_in('user[name]', :with => 'asdf1234')
  	fill_in('user[password]', :with => 'asdf1234')
  	first("input.btn").click()
  	assert page.has_css?('p#notice', text: 'Login successful.')

  	click_link('Destroy');
    page.driver.browser.switch_to.alert.accept
    assert page.has_css?('p#notice', text: 'User was successfully destroyed.')
  end
end
