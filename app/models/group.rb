class Group < ActiveRecord::Base
  belongs_to :user
  has_many :posts

  def refresh_info!
    update_columns(subscribers_count: vk_subscribers_count, views_count: vk_views, visitors_count: vk_visitors, reach: vk_reach,
                   reach_subscribers: vk_reach_subscribers)
  end

  private

  def vk_subscribers_count
    vk.groups.get_members(gid: vk_id, count: 1)[:count]
  end

  def vk_views
    vk_stats[:views]
  end

  def vk_visitors
    vk_stats[:visitors]
  end

  def vk_reach
    vk_stats[:reach]
  end

  def vk_reach_subscribers
    vk_stats[:reach_subscribers]
  end

  def vk
    @_vk ||= VkontakteApi::Client.new(user.token)
  end

  def vk_stats
    @_vk_stats ||= vk.stats.get(gid: vk_id, date_from: Date.yesterday.strftime('%Y-%m-%d')).last
  end
end
