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
    @isEdit = false #TODO: remove this, make distinct forms
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
      flash[:notice] = 'User was successfully created.'
      @user.send_activation_letter
      log_in(@user)
      respond_to do |format|
        format.js { render :json => { :html => render_to_string('_redirect'), redirect: true}, :content_type => 'text/json' }
        format.html { redirect_to @user}
      end
    end
  end


  # PATCH/PUT /users/1
  def update
    @isEdit = true #TODO: remove this, make distinct forms
    @isCreate = false
    oldmail = @user.email
    if @success = validate_input
      if access?(@user)        
        @success = @user.save
        email_changed = (oldmail != @user.email)
      else
        @success = false
        @no_right = true
      end
    end
    unless @success 
      respond_to do |format|
        format.js { render :json => { :html => render_to_string('_form'), redirect: false}, :content_type => 'text/json' }
        format.html { render :edit }
      end
    else
      if (email_changed)
        @user.send_activation_letter
      end
      flash[:notice] = 'User was successfully updated.' 
      respond_to do |format|
        format.js { render :json => { :html => render_to_string('_redirect'), redirect: true}, :content_type => 'text/json' }
        format.html { redirect_to @user }
      end
    end
  end

  # DELETE /users/1 
  def destroy
    if access?(@user)
      @user.destroy
      flash[:notice] = 'User was successfully destroyed.'
      respond_to do |format|
          format.html { redirect_to users_url }
      end
    else
      respond_to do |format|
        format.html { redirect_to '/500', notice: 'No right.' }
      end
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
	  return @user.validate_signup_input(user_params)
	end
end
