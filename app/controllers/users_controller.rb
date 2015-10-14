class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :init, only: [:new, :create, :edit, :update, :destroy]



  def new
  	@user = User.new
  end

  def create
  	decrypted=decrypted2=["","",""]
  	
  	begin
  	  	d1 = User.decrypt(user_params[:password])
  	  	d2 = User.decrypt(user_params[:password_confirmation])
  	  	@password_confirmation_not_match = d1 != d2
  	  	decrypted = d1.rpartition('|')
  	  	decrypted2 = d2.rpartition('|')
  	  	@decryption_failed = false
  	rescue
  		@decryption_failed = true
  		puts "Error #{$!}"
  	end
  	
  	err = @decryption_failed || @password_confirmation_not_match

  	#user = User.new(user_params)
  	#user.password = decrypted[0]
  	#user.password_confirmation = decrypted2[0]
  	#user.name = 
  	@name = user_params[:name].squish()
  	#user.email = 
  	@email = user_params[:email].squish()
  	user = User.new(password: decrypted[0], password_confirmation: decrypted2[0], name: @name, email: @email)
  	@user = user
  
    unless @name_empty = !user.has_name?
    	@name_too_short = !user.long_enough_name?
    	@name_too_long = !user.short_enough_name?
    	unless @name_too_short or @username_too_long
	    	unless @name_invalid = !user.valid_name?
	          	@name_taken = !user.unique_name?
	        end
        end
    end
    err ||= (@username_empty || @username_too_short || @username_too_long || @username_taken || @name_invalid)
  	unless @email_empty = !user.has_email?
  		unless @email_too_long = !user.short_enough_email?
		  	unless @email_invalid = !user.valid_email?
		  	  	@email_taken = !user.unique_email?
		  	end
  	  	end
  	end
  	err ||= (@email_empty || @email_too_long ||  @email_invalid || @email_taken)

	unless @decryption_failed
	  	@doublepost = !User.checksalt(decrypted[-1])
	end
	@password_empty = user.has_pass?

  	err ||= (@doublepost || @password_empty)

  	unless err
  	  	
  	  	if user.valid?
  	  	  	user.pseudosave
  	  	else
  	  		@user_errors = user.errors
  	  	end
  	end

  	#render '_form', :layout => false
    respond_to do |format|
      format.js { render :json => { :html => render_to_string('_form')}, :content_type => 'text/json' }
      format.html { render :new }
    end
  end
  	

  def show

  end

  private
    def init
  	  @publickey = User.key
  	  @salt = User.salt
  	  @user_errors = []
    end

    def set_user
      if params[:id] == '0'
      	@user = User.find(1)
      else
        @user = User.find(params[:id])
      end
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
