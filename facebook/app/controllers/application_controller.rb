class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :parse_facebook_cookies
  def parse_facebook_cookies
#    @facebook_cookies ||= Koala::Facebook::OAuth.new("412298645644235", "58b2e772c8e57d3baea107ea13b48c5e").get_user_info_from_cookie(cookies)
  end

end
