class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.integer :post_id

      t.datetime :post_at
      t.datetime :delete_at

      t.boolean :posted, default: false
      t.boolean :deleted, default: false
    end

    add_index :schedules, :post_id
  end
end
