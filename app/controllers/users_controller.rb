class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :init_form, only: [:new, :create, :edit, :update, :destroy]


  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  def new
  	@user = User.new
  end

  def show
  end

  def edit
  end


  # POST /users
  def create
    @isEdit = false
    @isCreate = true
  	@user = User.new
    if @success = validate_input
      @success = @user.save
    end
    unless @success
      respond_to do |format|
        format.js { render :json => { :html => render_to_string('_form'), redirect: false}, :content_type => 'text/json' }
        format.html { render :new }
      end
    else
      log_in(@user)
      respond_to do |format|
        format.js { render :json => { :html => render_to_string('_redirect'), redirect: true}, :content_type => 'text/json' }
        format.html { redirect_to @user, notice: 'User was successfully created.' }
      end
    end
  end


  # PATCH/PUT /users/1
  def update
    @isEdit = true
    @isCreate = false
    if @success = validate_input
      @success = @user.update({password: @password, password_confirmation: @password_confirmation, name: @name, email: @email})
    end
    unless @success 
      respond_to do |format|
        format.js { render :json => { :html => render_to_string('_form'), redirect: false}, :content_type => 'text/json' }
        format.html { render :edit }
      end
    else
      respond_to do |format|
        format.js { render :json => { :html => render_to_string('_redirect'), redirect: true}, :content_type => 'text/json' }
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
      end
    end
  end

  # DELETE /users/1 
  def destroy
    @user.destroy
    respond_to do |format|
        format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
    end
  end
  	



  private
    def init_form
  	  @publickey = User.key
  	  @salt = User.salt
    end

    def set_user
      if params[:id] == '0'
      	@user = User.find(1)
      else
        @user = User.find(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :password_encrypted, :password_confirmation_encrypted, :salt)
    end

	def validate_input
  	decrypted=decrypted2=["","",""]
  	err = false
    user = @user
    user.name = @name = user_params[:name].squish()
    user.email = @email = user_params[:email].squish()

    if  user_params[:password_encrypted] or user_params[:password_confirmation_encrypted]
    	begin
  	  	d1 = User.decrypt(user_params[:password_encrypted])
  	  	d2 = User.decrypt(user_params[:password_confirmation_encrypted])
  	  	@password_confirmation_not_match = d1 != d2
  	  	decrypted = d1.rpartition('|')
  	  	decrypted2 = d2.rpartition('|')
  	  	@decryption_failed = false
    	rescue
    		@decryption_failed = true
    	end
    else
      @password_confirmation_not_match = user_params[:password] != user_params[:password_confirmation]
      decrypted = [user.hash_pass(user_params[:password]),'|',params[:salt]]
      decrypted2 = [user.hash_pass(user_params[:password_confirmation]),'|',params[:salt]]
      @decryption_failed = false
    end
  	
  	err = @decryption_failed || @password_confirmation_not_match

  	
  	user.password = @password = decrypted[0]
  	user.password_confirmation = @password_confirmation = decrypted2[0]

  	#user = User.new(password: decrypted[0], password_confirmation: decrypted2[0], name: @name, email: @email)
  	#@user = user
  
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

	  return !err
	end
end
