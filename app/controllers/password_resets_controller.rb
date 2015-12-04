class PasswordResetsController < ApplicationController
  #get 'reset_request'  => 'password_resets#new'
  def new
  	init_request_form
  end

  #post 'send_reset_request'  => 'password_resets#create'
  def create
  	init_request_form
    @user = validate_email_input(user_params)
    err = @user.err
    if err
      respond_to do |format|
        format.js { render :json => { :html => render_to_string('request_form'), redirect: false}, :content_type => 'text/json' }
        format.html { render :new } 
      end       
    else
      @user.send_password_reset_letter
      flash[:notice] = 'Password request sent.'
      respond_to do |format|
        format.js { render :json => { :html => '', redirect: false}, :content_type => 'text/json' }
        format.html { redirect_to login_url }
      end
    end
  end

  #get password_resets/:token
  def edit
    init_reset_form 
  end

  #patch reset_password
  def reset
    err = true
    if init_reset_form
      @user.validate_password_input(user_params)
      err = @user.err
      p err
      p @user
      puts  @user
      @success = @user.save()
      err |= !@success
    end
    if err
      respond_to do |format|
        format.js { render :json => { :html => render_to_string('reset_form'), redirect: false}, :content_type => 'text/json' }
        format.html { render :edit } 
      end 
    else
      #@user.update_attribute(:password, user.password)
      #@user.update_attribute(:password, user.password_confirmation)
      flash[:notice] = 'Password reset success.'
      respond_to do |format|
        format.js { render :json => { :html => render_to_string('redirect'), redirect: true}, :content_type => 'text/json' }
        format.html { redirect_to login_url }
      end
    end
  end

  private
    def init_request_form
  	  @user = User.new

    end

    def init_reset_form
      @token =params[:token]
      pr = PasswordReset.find_token(@token)
      if pr
        @salt = User.salt
        @user = User.find_by(id: pr.user_id)
        return true
      end
      false
    end

    def user_params
      params.require(:user).permit(:email,:password, :password_confirmation, :salt)
    end

end
