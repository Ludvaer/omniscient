class UsersController < ApplicationController
  def new
  	@publickey = User.key
  	@salt = User.salt
  end
end
