class SessionsController < ApplicationController
	before_action :init_form
	def new
	end
	private
		def init_form
			@user = User.new
			@islogin = true
			@publickey = User.key
			@salt = User.salt
		end
end
