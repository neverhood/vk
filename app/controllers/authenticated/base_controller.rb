class Authenticated::BaseController < ApplicationController
  layout 'authenticated'

  before_filter :authenticate_user!

  def current_user_vk
    @current_user_vk ||= VkontakteApi::Client.new(current_user.token)
  end
end
