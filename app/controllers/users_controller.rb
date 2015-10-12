class UsersController < ApplicationController
  def new
  	@publickey = User.key
  end
end
