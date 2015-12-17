class AccountActivationsController < ApplicationController

	def create
		user = current_user
		user.send_activation_letter
		flash[:notice] = 'Activation letter sent.'
		@user = user
		respond_to do |format|
	        format.js { render :json => { :html => render_to_string('users/_redirect'), redirect: true}, :content_type => 'text/json' }
	        format.html { redirect_to @user }
	    end
	end

	def activate
		@aa = AccountActivation.find_token(params[:token])
		@link_already_activated = @aa && @aa.activated	
		if  @aa && !@aa.activated
			user = current_user
			@not_logged_in = !(logged_in?)
			@wrong_user = user && (@aa.user_id != user.id)
			if user && (@aa.user_id == user.id)
				@email_changed = user && (user.email != @aa.email)
				@user_already_activated= user.activated
				if  user && !@email_changed
					@aa.update_attribute(:activated, true)
					user.update_attribute(:activated, true)
					@success = true
					#TODO: clean all activation records with same email and other users if exists
				end
			end		
		end
	end
end
