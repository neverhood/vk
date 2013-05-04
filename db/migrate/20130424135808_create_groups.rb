class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.boolean :active, default: true

      t.integer :user_id, null: false
      t.integer :vk_id, null: false

      t.string :name
      t.string :screen_name
      t.string :group_type
      t.hstore :photo_urls

      t.integer :subscribers_count
      t.integer :views_count
      t.integer :visitors_count
      t.integer :reach
      t.integer :reach_subscribers

      t.hstore :auto_exchange_conditions

      t.timestamps
    end

    add_index :groups, :user_id
    add_index :groups, :vk_id, unique: true
  end
end
