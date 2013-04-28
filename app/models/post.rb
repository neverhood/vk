class Post < ActiveRecord::Base
  belongs_to :group
  has_and_belongs_to_many :photos

  validates :body, length: { within: 0..10000 }

  before_destroy -> { photos.clear }

  default_scope -> { order('posts.created_at DESC') }
end
