class Post < ActiveRecord::Base
  belongs_to :group

  validates :body, length: { within: 0..10000 }
end
