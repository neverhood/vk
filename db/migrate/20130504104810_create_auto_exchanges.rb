class CreateAutoExchanges < ActiveRecord::Migration
  def change
    create_table :auto_exchanges do |t|
      t.integer :user_ids, array: true
      t.integer :post_ids, array: true

      t.integer :requestor_auto_exchange_schedule_ids, array: true
      t.integer :acceptor_auto_exchange_schedule_ids,  array: true

      t.boolean :confirmed_by_requestor, default: false
      t.boolean :confirmed_by_acceptor,  default: false

      t.boolean :finished, default: false

      t.timestamps
    end
  end
end
