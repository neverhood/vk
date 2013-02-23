class SessionsController < ApplicationController
  def callback
    if session[:state].present? and session[:state] != params[:state]
      redirect_to root_path, alert: I18n.t('flash.sessions.callback.alert') and return
    end

    @vk = VkontakteApi.authorize(code: params[:code])

    session[:token], session[:vk_id] = @vk.token, @vk.user_id

    redirect_to root_url, notice: I18n.t('flash.sessions.callback.notice')
  end

  def destroy
    session[:token], session[:vk_id] = nil, nil

    redirect_to root_path, notice: I18n.t('flash.sessions.destroy.notice')
  end
end
