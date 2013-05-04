class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :group_id, null: false
      t.text :body

      t.integer :posted_times, default: 0
      t.boolean :from_group, default: true
      t.boolean :repost
      t.hstore  :vk_details # repost only

      t.boolean :available_for_exchanges, default: false

      t.timestamps
    end

    add_index :posts, :available_for_exchanges
    add_index :posts, :group_id
  end
end
