class Post < ActiveRecord::Base
  belongs_to :group
  has_and_belongs_to_many :photos

  validates :body, length: { within: 0..10000 }

  before_destroy -> { photos.clear }

  default_scope -> { order('posts.created_at DESC') }

  def vk_params
    { owner_id: -group.vk_id, message: body, attachments: _vk_photos, from_group: 1 }
  end

  private

  def _vk_photos
    photos.select('photos.info').map { |photo| photo.info['id'] }.join(',')
  end
end
