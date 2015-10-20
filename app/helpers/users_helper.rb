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
end
