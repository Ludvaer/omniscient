class UsersController < ApplicationController
  def new
  	@publickey = User.key
  	@salt = User.salt
  end

  def create
  	@publickey = User.key
  	@salt = User.salt
  	#@name = params[:name]
  	decrypted = User.decrypt(params[:password]).rpartition('|')
  	@name = params[:name]
  	@password = decrypted[0]
  	@email = params[:email]
  	@doublepost = !User.checksalt(decrypted[-1])
  	render '_form', :layout => false
  end
end
