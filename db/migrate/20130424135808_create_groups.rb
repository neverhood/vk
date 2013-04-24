class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.boolean :active, default: true
      t.integer :user_id, null: false
      t.string :name
      t.string :screen_name
      t.hstore :photo_urls

      t.timestamps
    end

    add_index :groups, :user_id
  end
end
