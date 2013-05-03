class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.integer :post_id
      t.datetime :post_at
      t.boolean :finished

      t.timestamps
    end
  end
end
