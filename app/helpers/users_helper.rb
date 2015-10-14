module UsersHelper
	  # Returns the Gravatar for the given user.
  def gravatar_for(user)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    link_to(image_tag(gravatar_url, alt: "gravatar", class: "gravatar"), @user)
  end
end
