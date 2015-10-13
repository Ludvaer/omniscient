class UsersController < ApplicationController
  def init
  	@publickey = User.key
  	@salt = User.salt
  	@user_errors = []
  end


  def new
  	init
  end

  def create
  	init
  	decrypted=["","",""]
  	begin
  	  	decrypted = User.decrypt(params[:password]).rpartition('|')
  	  	@decryption_failed = false
  	rescue
  		@decryption_failed = true
  		puts "Error #{$!}"
  	end
  	err = @decryption_failed

  	@name = params[:name].squish()
  	#@username_empty = @name.
  	
  	@email = params[:email].squish()
  	
  	user = User.new(name: @name, email: @email)
  	@user = user

    unless @username_empty = !user.has_name?
    	@username_too_short = !user.long_enough_name?
    	@username_too_long = !user.short_enough_name?
    	unless @username_too_short or @username_too_long
          	@username_taken = !user.unique_name?
        end
    end
    err ||= (@username_empty || @username_too_short || @username_too_long || @username_taken)

  	unless @email_empty = !user.has_email?
  		unless @email_too_long = !user.short_enough_mail?
  	  	  	@email_taken = !user.unique_email?
  	  	end
  	end
  	err ||= (@email_empty || @email_too_long || @email_taken)

  	unless err
  	  	@password = decrypted[0]
  	  	@doublepost = !User.checksalt(decrypted[-1])
  	  	if user.valid?
  	  	  	user.pseudosave
  	  	else
  	  		@user_errors = user.errors
  	  	end
  	end

  	render '_form', :layout => false
  end
end
