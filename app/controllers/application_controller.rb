APPNAME = 'Omni<span style="font-size:0;"> </span>scent'.html_safe
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
