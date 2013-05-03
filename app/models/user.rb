class User < ActiveRecord::Base
  validates :vk_id, presence: true
  validates :name, presence: true

  has_many :groups, dependent: :destroy
  has_many :posts, through: :groups
  has_many :schedules, through: :posts
  has_many :photos
end
