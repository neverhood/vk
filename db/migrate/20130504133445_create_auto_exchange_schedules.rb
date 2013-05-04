class CreateAutoExchangeSchedules < ActiveRecord::Migration
  def change
    create_table :auto_exchange_schedules do |t|
      t.integer :post_id
      t.integer :auto_exchange_id

      t.datetime :post_at
      t.datetime :delete_at

      t.boolean :posted, default: false
      t.boolean :deleted, default: false

      t.boolean :changed,  default: false
      t.boolean :declined, default: false
      t.string :message
    end
  end
end
