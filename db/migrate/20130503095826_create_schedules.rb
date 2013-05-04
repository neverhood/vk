class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.integer :post_id

      t.datetime :post_at
      t.datetime :delete_at

      t.boolean :posted
      t.boolean :deleted

      t.timestamps
    end
  end
end
