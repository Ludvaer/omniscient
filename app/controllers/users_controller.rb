class UsersController < ApplicationController
  def init
  	@publickey = User.key
  	@salt = User.salt
  end


  def new
  	init
  end

  def create
  	init
  	decrypted = User.decrypt(params[:password]).rpartition('|')
  	@name = params[:name].squish()
  	#@username_empty = @name.
  	@password = decrypted[0]
  	@email = params[:email].squish()
  	@doublepost = !User.checksalt(decrypted[-1])

  	user = User.new(name: @name, email: @email)

    unless @username_empty = !user.hasName?
      	@username_taken = !user.uniqueName?
    end

  	unless @mail_empty = !user.hasName?
  	  	@mail_taken = !user.uniqueMail?
  	end

  	if (user.valid?)
  	  	user.pseudosave()
  	end

  	render '_form', :layout => false
  end
end
