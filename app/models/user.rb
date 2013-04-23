class User < ActiveRecord::Base
  validates :vk_id, presence: true
  validates :name, presence: true
end
