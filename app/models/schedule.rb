class Schedule < ActiveRecord::Base
  has_one :user, :through => :post
  belongs_to :post

  validates :post_at, presence: true

  def publish_later!
    true
  end

  def publish_now!
    true
  end
end
