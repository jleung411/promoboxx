class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :parse_facebook_cookies
  def parse_facebook_cookies
    logger.info @facebook_cookies
    logger.info "parse_facebook_cookies"
#   @facebook_cookies ||= Koala::Facebook::OAuth.new("411274062413360", "0d8d17b1f0c10af1f0481644c5ad0cdf").get_user_info_from_cookie(cookies)
    logger.info @facebook_cookies
  end

end
