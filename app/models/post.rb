class Post < ActiveRecord::Base
  belongs_to :group
  has_one :user, through: :group
  has_and_belongs_to_many :photos
  has_many :schedules, dependent: :destroy

  validates :body, length: { within: 2..10000 }, if: -> { photo_ids.none? and not repost? }

  before_destroy -> { photos.clear }

  default_scope -> { order('posts.created_at DESC') }
  scope :available_for_exchanges, -> { where(available_for_exchanges: true) }

  def publish!
    vk = VkontakteApi::Client.new(user.token)

    repost?? repost!(vk) : post!(vk)
  end

  protected

  def repost!(vk)
    vk.wall.repost(gid: group.vk_id, object: _vk_object, message: body)
  end

  def post!(vk)
    vk.wall.post _vk_params
  end

  private

  def _vk_photos
    photos.select('photos.info').map { |photo| photo.info['id'] }.join(',')
  end

  def _vk_object
    $1 if vk_details['url'] =~ /(wall.*\d+_\d+)/
  end

  def _vk_params
    { owner_id: -group.vk_id, message: body, attachments: _vk_photos, from_group: 1 }
  end
end
