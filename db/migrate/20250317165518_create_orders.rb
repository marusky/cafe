class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.integer :state, null: false, default: 0
      t.references :customer, foreign_key: true, type: :uuid, null: false
      t.time :finalized_at

      t.timestamps
    end
  end
end
