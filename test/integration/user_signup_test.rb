require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
	include Capybara::DSL

	def setup
		setup_capybara
	end

	test 'signup validation check' do
		with_and_without_js do
			s = 'asdf'
			name = standart_name s
			pass = standart_pass s
			mail = standart_mail s
			standart_signup s
			standart_logout s

			visit('/signup')
			fill_in('user[name]', :with => name)
			fill_in('user[password]', :with => pass)
			fill_in('user[password_confirmation]', :with => pass)
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
			fill_in('user[password_confirmation]', :with => pass)
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
			fill_in('user[password]', :with => s+'pss')
			fill_in('user[password_confirmation]', :with => pass)
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
			fill_in('user[email]', :with => mail)
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

			standart_destroy s
		end
	end
end
