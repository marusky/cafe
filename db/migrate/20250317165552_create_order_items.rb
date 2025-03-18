class CreateOrderItems < ActiveRecord::Migration[8.0]
  def change
    create_table :order_items do |t|
      t.references :product, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.integer :cost, null: false, default: 0
      t.integer :amount, null: false, default: 1

      t.timestamps
    end
  end
end
