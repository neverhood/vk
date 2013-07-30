class ApplicationController < ActionController::Base
  include VkAuthenticable
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate!

  private

  def authenticate!
    authenticate_or_request_with_http_basic do |user_name, password|
      session[:admin] = ( user_name == ENV['VK_LOGIN'] and password == ENV['VK_PASSWORD'] )
    end
  end
end
