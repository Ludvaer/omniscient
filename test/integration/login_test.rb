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
   	visit('/signup')
  	fill_in('user[name]', :with => 'qwerty1234')
  	fill_in('user[password]', :with => 'qwerty1234')
  	fill_in('user[password_confirmation]', :with => 'qwerty1234')
  	fill_in('user[email]', :with => 'qwerty1234@qwerty.qwerty')
  	first("input.btn").click()
  	wait_for_ajax
  	assert page.has_css?('p#notice', text: 'User was successfully created.'), 'User was successfully created. Message'
  	assert page.has_css?('h2', text: 'qwerty1234'),  'User, created. Redirected to profile.'

  	visit('/login')
  	fill_in('user[name]', :with => 'qwerty1234')
  	fill_in('user[password]', :with => 'qwerty1234')
  	first("input.btn").click()
  	wait_for_ajax
  	assert page.has_css?('p#notice', text: 'Login successful.'), 'Valid login created.'
  	assert page.has_css?('h2', text: 'qwerty1234'),  'Login succesful. Redirected to profile.'

  	visit('/logout')
  	visit('/login')
  	fill_in('user[name]', :with => '')
  	fill_in('user[password]', :with => 'qwerty1234')
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
  	fill_in('user[password]', :with => 'qwerty1234')
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
  	fill_in('user[password]', :with => 'qwerty1234')
  	first("input.btn").click() 
  	assert page.has_css?('div#name-empty', visible: false)
  	assert page.has_css?('div#name-too-short', visible: false)
  	assert page.has_css?('div#name-too-long', visible: false)
  	assert page.has_css?('div#name-invalid', visible: false)
  	assert page.has_css?('div#name-unknown', visible: true)
  	assert page.has_css?('div#password-empty', visible: false)
	assert page.has_css?('div#password-invalid', visible: false)


  	fill_in('user[name]', :with => 'qwerty1234')
  	fill_in('user[password]', :with => 'QWEASDasdqqweqw12318473232149508')
  	first("input.btn").click() 
  	assert page.has_css?('div#name-empty', visible: false)
  	assert page.has_css?('div#name-too-short', visible: false)
  	assert page.has_css?('div#name-too-long', visible: false)
  	assert page.has_css?('div#name-invalid', visible: false)
  	assert page.has_css?('div#name-unknown', visible: false)
  	assert page.has_css?('div#password-empty', visible: false)
  	assert page.has_css?('div#password-invalid', visible: true)


  	visit('/login')
  	fill_in('user[name]', :with => 'qwerty1234')
  	fill_in('user[password]', :with => 'qwerty1234')
  	first("input.btn").click()
  	wait_for_ajax
  	assert page.has_css?('p#notice', text: 'Login successful.'), 'Valid login created.'
  	assert page.has_css?('h2', text: 'qwerty1234'),  'Login succesful. Redirected to profile.'


  	click_link('Destroy');
    page.driver.browser.switch_to.alert.accept
    end

    test 'remember me' do
	   	visit '/signup' 
	  	fill_in('user[name]', :with => 'hjkl1234')
	  	fill_in('user[password]', :with => 'hjkl1234')
	  	fill_in('user[password_confirmation]', :with => 'hjkl1234')
	  	fill_in('user[email]', :with => 'hjkl1234@hjkl.hjkl')
	  	first("input.btn").click()
	  	wait_for_ajax
	  	assert page.has_css?('p#notice', text: 'User was successfully created.'), 'User was successfully created. Message'
	  	assert page.has_css?('h2', text: 'hjkl1234'),  'User, created. Redirected to profile.'
	  	assert page.has_css?('a.sign', text: 'Profile'),  'Profile link'
	  	assert page.has_css?('a.sign', text: 'Log out'),  'Log out link'

	  	visit('/logout')
	  	assert page.has_css?('a.sign', text: 'Sign up'),  'Forget on logout. Sign up link'
	  	assert page.has_css?('a.sign', text: 'Log in'),  'Forget on logout. Log in link'

	  	visit('/login')
	  	fill_in('user[name]', :with => 'hjkl1234')
	  	fill_in('user[password]', :with => 'hjkl1234')
	  	first("input.btn").click()
	  	wait_for_ajax
	  	assert page.has_css?('p#notice', text: 'Login successful.'), 'Valid login created.'
	  	assert page.has_css?('h2', text: 'hjkl1234'),  'Login succesful. Redirected to profile.'
	  	assert page.has_css?('a.sign', text: 'Profile'),  'Profile link'
	  	assert page.has_css?('a.sign', text: 'Log out'),  'Log out link'


	  	Capybara.reset_sessions!

	  	visit('/login')
		assert page.has_css?('a.sign', text: 'Sign up'),  'Forget on session reset. Sign up link'
	  	assert page.has_css?('a.sign', text: 'Log in'),  'Forget on session reset. Log in link'

	  	fill_in('user[name]', :with => 'hjkl1234')
	  	fill_in('user[password]', :with => 'hjkl1234')
	  	check "Remember me"
	  	first("input.btn").click()
	  	wait_for_ajax
	  	assert page.has_css?('p#notice', text: 'Login successful.'), 'Login with remember  successful.'
	  	assert page.has_css?('h2', text: 'hjkl1234'),  'Login with remember succesful. Redirected to profile.'
	  	assert page.has_css?('a.sign', text: 'Profile'),  'Login with remember succesful. Profile link'
	  	assert page.has_css?('a.sign', text: 'Log out'),  'Login with remember succesful. Log out link'

	  	reset!

	  	visit('/login')

	  	assert page.has_css?('a.sign', text: 'Profile'),  'Remember on session reset. Profile link'
	  	assert page.has_css?('a.sign', text: 'Log out'),  'Remember on session reset. Log out link'

	  	click_on 'Profile'
	  	click_link 'Destroy'
	  	page.driver.browser.switch_to.alert.accept

    end 
end
