class SessionsController < ApplicationController
  def callback
    if session[:state].present? and session[:state] != params[:state]
      redirect_to root_path, alert: I18n.t('flash.sessions.callback.alert') and return
    end

    @vk = VkontakteApi.authorize(code: params[:code])

    user = User.find_by(vk_id: @vk.user_id) || create_user_with_vk_details
    user.update wall_post_enabled: false

    sign_in user

    redirect_to root_url, notice: I18n.t('flash.sessions.callback.notice')
  end

  def destroy
    sign_out

    redirect_to root_path, notice: I18n.t('flash.sessions.destroy.notice')
  end

  def update
    vk = VkontakteApi::Client.new(extracted_token)

    begin
      vk.wall.post
    rescue Exception => exception
      if exception.message =~ /One of the parameters specified was missing or invalid/
        current_user.update token: extracted_token, wall_post_enabled: true
        redirect_to user_path, notice: I18n.t('flash.sessions.update.notice')
      else
        redirect_to user_path, alert: I18n.t('flash.sessions.update.alert')
      end
    end
  end

  private

  def create_user_with_vk_details
    vk_details = @vk.users.get(uid: @vk.user_id).first

    User.create(vk_id: vk_details[:uid], name: "#{ vk_details[:first_name] } #{ vk_details[:last_name] }", token: @vk.token)
  end

  def extracted_token
    token = params.require(:session)[:token]
    token =~ /access_token=(\w+)/ ? $1 : token
  end
end
