ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end


def setup_capybara
  	Capybara.current_driver = :selenium
  	#Capybara.app_host = "http://localhost:3000"
  	Capybara.run_server = true #Whether start server when testing
    Capybara.server_port = 8200
end

def wait_for_ajax
	Timeout.timeout(Capybara.default_max_wait_time) do
	    loop until finished_all_ajax_requests?
	end
end

def finished_all_ajax_requests?
	page.evaluate_script('jQuery.active').zero?
end
