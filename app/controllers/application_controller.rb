class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  before_filter :prepare_vk_auth, unless: -> { user_signed_in? }

  helper_method :user_signed_in?

  def user_signed_in?
    session[:token].present? and session[:vk_id].present?
  end

  private

  def prepare_vk_auth
    srand

    session[:state] ||= Digest::MD5.hexdigest(rand.to_s)
    @vk_url = VkontakteApi.authorization_url(scope: [:friends, :groups, :offline, :notify], state: session[:state])
  end
end
