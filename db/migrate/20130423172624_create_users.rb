class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :vk_id, null: false
      t.string :token
      t.boolean :wall_post_enabled, default: false
      t.string :name, null: false

      t.timestamps
    end

    add_index :users, :vk_id, unique: true
  end
end
