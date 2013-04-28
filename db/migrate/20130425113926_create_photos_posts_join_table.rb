class CreatePhotosPostsJoinTable < ActiveRecord::Migration
  def change
    create_table :photos_posts do |table|
      table.integer :photo_id
      table.integer :post_id
    end

    add_index :photos_posts, [ :photo_id, :post_id ], unique: true
    add_index :photos_posts, :post_id
  end
end
