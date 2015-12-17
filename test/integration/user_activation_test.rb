require 'test_helper'

class UserActivationTest < ActionDispatch::IntegrationTest
	include Capybara::DSL

	def setup
		setup_capybara
	end	

	def signup_and_activate(s)
		visit '/signup'
		assert page.has_no_css? '#email-not-confirmed-notice'
		c = ActionMailer::Base.deliveries.size		
		standart_signup s
		assert_equal ActionMailer::Base.deliveries.size, c+1
		assert page.has_css? '#email-not-confirmed-notice'
		mail = ActionMailer::Base.deliveries[-1]
		link =  URI.extract(mail.body.encoded)[-1]
		activate_link link, s
		assert_text 'successfully confirmed'
		return link
	end

	def activate_link(link, s)
		visit link
		if  page.has_css?('a', :text => 'Log in')
			standart_login s,true,true
			wait_for_ajax
		end
	end

	test "email confirmation" do
		s = 'activationtest'	
		signup_and_activate s	
		visit root_url
		assert_no_text 'successfully'
		standart_destroy s
	end


	test "double email confirmation" do
		s = 'doubleactivationtest'	
		link = signup_and_activate s
		activate_link link, s
		assert_no_text 'successfully'
		assert_text 'failed'
		standart_destroy s
	end
end

