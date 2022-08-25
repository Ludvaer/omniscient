require 'test_helper'

class UserEditTest < ActionDispatch::IntegrationTest
	include Capybara::DSL

	def setup
		setup_capybara
	end
	test 'valid edit check' do
		with_and_without_js do
			s = 'validedittest'
			#name = standart_name s
			pass = standart_pass s
			#mail = standart_mail s

			s1 = 'editedtesteditedab'
			name1 = standart_name s1
			pass1 = standart_pass s1
			mail1 = standart_mail s1

			standart_signup s

			click_link 'Edit'

			fill_in('user[old_password]', with: pass)
		    fill_in('user[name]', with: name1)
		    fill_in('user[password]', with: pass1)
		    fill_in('user[password_confirmation]', with: pass1)
		    fill_in('user[email]', with: mail1)

		    first("input.btn").click()
		    wait_for_ajax
			assert_text 'successfully updated'
			assert page.has_css?('p#notice', text: 'User was successfully updated.'), 'User successfully updated message'

			# "#{s} updated to #{s1}"

			assert page.has_no_css?('div#old-password-invalid', visible: false)

		    standart_logout s1
		    wait_for_ajax

		    standart_login s1

		    click_link 'Profile'
		    assert_text name1
		    assert_text mail1
		    assert_selector('h2', :text => name1)
			standart_destroy s1
		end
	end


	test 'wrong pass edit check' do
		with_and_without_js do
			s = 'wrongpasstest'
			#name = standart_name s
			#pass = standart_pass s
			#mail = standart_mail s

			s1 = 'wrongpasstestedited'
			name1 = standart_name s1
			pass1 = standart_pass s1
			mail1 = standart_mail s1

			standart_signup s

			click_link 'Edit'

			fill_in('user[old_password]', with: pass1)
		    fill_in('user[name]', with: name1)
		    fill_in('user[password]', with: pass1)
		    fill_in('user[password_confirmation]', with: pass1)
		    fill_in('user[email]', with: mail1)

		    first("input.btn").click()
		    wait_for_ajax
			
			assert page.has_css?('div#old-password-invalid', visible: true)



		    #assert_text name1
		    #assert_text mail1
		    #assert_selector('h2', :text => name1)
			standart_destroy s
		end
	end


end