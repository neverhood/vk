class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :group_id, null: false
      t.text :body

      t.boolean :posted, default: false

      t.timestamps
    end

    add_index :posts, :group_id
  end
end
