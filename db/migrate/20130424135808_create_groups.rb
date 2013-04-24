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

      t.timestamps
    end

    add_index :groups, :user_id
    add_index :groups, :vk_id, unique: true
  end
end
