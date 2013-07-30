class Schedule < ActiveRecord::Base
  has_one :user, :through => :post
  belongs_to :post

  validates :post_at, presence: true

  after_commit -> { ScheduleWorker.perform_at(post_at, id); logger.debug('====') }, on: :create

  def publish_now!
    if post.publish!
      update_column(:posted, true)
    end
  end

end
