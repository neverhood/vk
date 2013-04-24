require 'active_support/concern'

module VkAuthenticable
  extend ActiveSupport::Concern

  included do
    helper_method :user_signed_in?, :current_user, :vk_token_url

    before_filter :prepare_vk_url, if: -> { not user_signed_in? }
  end

  def authenticate_user!
    redirect_to root_path unless user_signed_in?
  end

  def sign_in user
    session[:user_id] = user.id
  end

  def sign_out
    session[:user_id] = nil
  end

  def user_signed_in?
    session[:user_id] = nil if User.where(id: session[:user_id]).none?
    session[:user_id].present?
  end

  def current_user
    User.find(session[:user_id])
  end

  def prepare_vk_url
    srand

    session[:state] ||= Digest::MD5.hexdigest(rand.to_s)
    @vk_url = VkontakteApi.authorization_url(scope: permissions_scope, state: session[:state])
  end

  def vk_token_url
    @vk_url = VkontakteApi.authorization_url(type: :client, scope: permissions_scope, redirect_uri: Settings.vk.token_url)
  end

  private

  def permissions_scope
    [ :friends, :groups, :offline, :notify, :wall, :stats, :photos, :audio, :video ]
  end

end
