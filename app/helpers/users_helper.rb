module UsersHelper
	  # Returns the Gravatar for the given user.
  def gravatar_for(user)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    link_to(image_tag(gravatar_url, alt: "gravatar", class: "gravatar"), @user, :class => 'avatar' )
  end

  def errors_for(user, field)
    errors = user.errors.to_hash(true)[field]
    errors.map{ |message|  "<div class='error'>#{message}</div>"}.join().html_safe
  end


  def user_email_field(f,is_signup = false)
    hidden_attr = 'hidden="hidden"'
    existance_error = if is_signup then  %Q{<div class="error" #{  hidden_attr unless @user.email_taken } id="email-taken" >  User with such email already registered. </div>} 
      else %Q{<div class="error" #{  hidden_attr unless @user.email_unknown } id="email-taken" >  No user with such email registered. </div>} end

    %Q{
      <div class="field">
          #{f.label :email, "Em@il"}
          #{f.email_field :email}
        <div class="error"  #{ 'hidden="hidden"' unless @user.email_empty } id="email-empty">
          Email should be present.</div> 
        <div class="error"  #{ 'hidden="hidden"' unless @user.email_too_long } id="email-too-long">
          Too long. Emails loger than 255 are not allowed.</div>
        <div class="error" #{ 'hidden="hidden"' unless @user.email_invalid } id="email-invalid">
          Does not look much like email.</div>  
        #{existance_error}
      </div>
    }.html_safe
  end

  def user_password_field(f,is_signup = false)
    validness_error =  %Q{<div class="error" <%= 'hidden="hidden"' unless @user.password_invalid %> id="password-invalid">
        Invalid password, or wrong username.</div>} unless is_signup
    %Q{
      <div class="field">
      #{ f.label :password }
      #{ f.password_field :password }
      <div class="error"  #{ 'hidden="hidden"' unless @user.password_empty } id="password-empty">
        Password should not be empty.</div> 
      #{ validness_error }
      </div>
    }.html_safe
  end

  def user_password_confirmation_field(f)
    %Q{
      <div class="field">
      #{ f.label :password_confirmation }
      #{ f.password_field :password_confirmation }
      <div class="error"  #{ 'hidden="hidden"' unless @user.password_confirmation_empty } id="password-empty">
        Password confirmation should not be empty.</div>  
      <div class="error" #{ 'hidden="hidden"' unless @user.password_confirmation_not_match } id="password-confirmation-not-match" >
        Passwords do not match.</div> 
      </div>
    }.html_safe
  end

  def user_salt_field
    %Q{<input type="text" style="display: none;" hidden="hidden" name="user[salt]" id = "salt" value="#{ @salt }"/>}.html_safe
  end
end
