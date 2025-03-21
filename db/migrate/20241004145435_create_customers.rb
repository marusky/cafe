class CreateCustomers < ActiveRecord::Migration[8.0]
  def change
    create_table :customers, id: :string do |t|
      # t.string :id, null: false, limit: 36
      t.string :name
      t.integer :balance, null: false, default: 0

      t.timestamps
    end
  end
end
