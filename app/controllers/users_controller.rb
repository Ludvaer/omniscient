class UsersController < ApplicationController
  def new
  	@publickey = User.key
  	@salt = User.salt
  end

  def create
  	@publickey = User.key
  	@salt = User.salt
  	#@name = params[:name]
  	@name = User.decrypt(params[:password])
  	@password = params[:password]
  	@email = params[:email]
  	render '_form', :layout => false
  end
end
