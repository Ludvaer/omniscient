ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'

class ActiveSupport::TestCase
  include Capybara::DSL
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def no_js_driver
    :rack_test
  end

  # Add more helper methods to be used by all tests here...
  def setup_capybara

    Capybara.default_driver = :selenium
    #Capybara.app_host = "http://localhost:3000"
    Capybara.run_server = true #Whether start server when testing
    Capybara.server_port = 8200
  end

  def with_and_without_js &test_block
      Capybara.use_default_driver
      test_block.call()
      Capybara.current_driver = no_js_driver
      test_block.call()
  end

  def accept_alert
    if Capybara.current_driver == :selenium
      page.driver.browser.switch_to.alert.accept    
    end
  end

  def standart_name s
    s + 'name'
  end 
  def standart_pass s
    s + 'pass'
  end 
  def standart_mail s
    s + '_test_mail@'+ s + '.' + s
  end 

  def logged_in s
    assert page.has_css?('a.sign', text: 'Profile'),  'Logged in. Profile link'
    assert page.has_css?('a.sign', text: 'Log out'),  'Logged in. Log out link'
  end

  def check_not_logged_in s
    assert page.has_css?('a.sign', text: 'Sign up'),  'Logged out. Sign up link'
    assert page.has_css?('a.sign', text: 'Log in'),  'Logged out. Log in link'
  end

  def standart_signup s
    visit('/signup')
    name = standart_name s
    pass = standart_pass s
    mail = standart_mail s
    fill_in('user[name]', with: name)
    fill_in('user[password]', with: pass)
    fill_in('user[password_confirmation]', with: pass)
    fill_in('user[email]', with: mail)
    first("input.btn").click()
    wait_for_ajax
    assert page.has_css?('p#notice', text: 'User was successfully created.'), 'standart signup, get success message'
    assert page.has_css?('h2', text: name), 'Standart signup, get profile page header'
    logged_in s
  end

  def standart_login s, remember = false
    name = s + 'name'
    pass = s + 'pass'
    visit('/login')
    fill_in('user[name]', :with => name)
    fill_in('user[password]', :with => pass)
    check "Remember me" if remember
    first("input.btn").click()
    wait_for_ajax
    assert page.has_css?('p#notice', text: 'Login successful.'), 'standart login, get success mssage'
    assert page.has_css?('h2', text: name), 'standart login, get profile page header'
    logged_in s
  end

  def standart_logout s
    visit('/logout')
    check_not_logged_in s
  end

  def standart_destroy s
    standart_login s
    click_link 'Destroy'
    accept_alert
    assert page.has_css?('p#notice', text: 'User was successfully destroyed.')
  end

  def wait_for_ajax
    if Capybara.current_driver == no_js_driver
      return
    end
    Timeout.timeout(Capybara.default_max_wait_time) do
        loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end

end


