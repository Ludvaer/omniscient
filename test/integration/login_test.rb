require 'test_helper'

class LoginTest < ActionDispatch::IntegrationTest
	include Capybara::DSL
  # test "the truth" do
  #   assert true
  # end
	def setup
		setup_capybara
	end

	test 'login data validation' do
		with_and_without_js do
		  	s = 'qwerty'
	  	    name = standart_name s
		    pass = standart_pass s
		  	standart_signup s

		  	standart_logout s

		  	visit login_path(default_test_url_options)
		  	fill_in('user[name]', :with => '')
		  	fill_in('user[password]', :with => pass)
		  	first("input.btn").click() 
		  	assert page.has_css?('div#name-empty', visible: true)
		  	assert page.has_css?('div#name-too-short', visible: false)
		  	assert page.has_css?('div#name-too-long', visible: false)
		  	assert page.has_css?('div#name-invalid', visible: false)
		  	assert page.has_css?('div#name-unknown', visible: false)
		  	assert page.has_css?('div#password-empty', visible: false)
		  	assert page.has_css?('div#password-invalid', visible: false)

		  	fill_in('user[name]', :with => 'q')
		  	fill_in('user[password]', :with => '')
		  	first("input.btn").click() 
		  	assert page.has_css?('div#name-empty', visible: false)
		  	assert page.has_css?('div#name-too-short', visible: true)
		  	assert page.has_css?('div#name-too-long', visible: false)
		  	assert page.has_css?('div#name-invalid', visible: false)
		  	assert page.has_css?('div#name-unknown', visible: false)
		  	assert page.has_css?('div#password-empty', visible: true)
			assert page.has_css?('div#password-invalid', visible: false)

		  	fill_in('user[name]', :with => 'qweasdzxcfqweasdzxcfqweasdzxcfqweasdzxcfqweasdzxcf1')
		  	fill_in('user[password]', :with => pass)
		  	first("input.btn").click() 
		  	assert page.has_css?('div#name-empty', visible: false)
		  	assert page.has_css?('div#name-too-short', visible: false)
		  	assert page.has_css?('div#name-too-long', visible: true)
		  	assert page.has_css?('div#name-invalid', visible: false)
		  	assert page.has_css?('div#name-unknown', visible: false)
		  	assert page.has_css?('div#password-empty', visible: false)
			assert page.has_css?('div#password-invalid', visible: false)

			fill_in('user[name]', :with => '!@#^$#%^#^*^&$*')
		  	fill_in('user[password]', :with => 'asdfasdfq4tq3tc')
		  	first("input.btn").click() 
		  	assert page.has_css?('div#name-empty', visible: false)
		  	assert page.has_css?('div#name-too-short', visible: false)
		  	assert page.has_css?('div#name-too-long', visible: false)
		  	assert page.has_css?('div#name-invalid', visible: true)
		  	assert page.has_css?('div#name-unknown', visible: false)
		  	assert page.has_css?('div#password-empty', visible: false)
			assert page.has_css?('div#password-invalid', visible: false)

			fill_in('user[name]', :with => 'QWEASDasdqqweqw12318473232149508')
		  	fill_in('user[password]', :with => pass)
		  	first("input.btn").click() 
		  	assert page.has_css?('div#name-empty', visible: false)
		  	assert page.has_css?('div#name-too-short', visible: false)
		  	assert page.has_css?('div#name-too-long', visible: false)
		  	assert page.has_css?('div#name-invalid', visible: false)
		  	assert page.has_css?('div#name-unknown', visible: true)
		  	assert page.has_css?('div#password-empty', visible: false)
			assert page.has_css?('div#password-invalid', visible: false)


		  	fill_in('user[name]', :with => name)
		  	fill_in('user[password]', :with => 'QWEASDasdqqweqw12318473232149508')
		  	first("input.btn").click() 
		  	assert page.has_css?('div#name-empty', visible: false)
		  	assert page.has_css?('div#name-too-short', visible: false)
		  	assert page.has_css?('div#name-too-long', visible: false)
		  	assert page.has_css?('div#name-invalid', visible: false)
		  	assert page.has_css?('div#name-unknown', visible: false)
		  	assert page.has_css?('div#password-empty', visible: false)
		  	assert page.has_css?('div#password-invalid', visible: true)


		  	standart_destroy s
		end
    end

    test 'remember me' do
    	with_and_without_js do
    		#TODO fix reset
    		s = 'ijkl'
		   	#signup
		  	standart_signup s
		  	#logput
		  	standart_logout s
		  	#login with no remember
		  	standart_login s, false
		  	#reset and reopen login page
		  	#Capybara.reset!
		  	#visit('/login')		  	
		  	visit resession_path(default_test_url_options)
		  	#check that not logged in anymore
			check_not_logged_in s

			#logout and login with remember
			standart_logout s
		  	standart_login s, true
		  	#reset and reopen login page
		  	#Capybara.reset!
		  	#visit('/login')		  	
		  	visit resession_path(default_test_url_options)
		  	#check if still logged in
			logged_in s
			#delete user
		  	standart_destroy s
	    end
    end 
end
