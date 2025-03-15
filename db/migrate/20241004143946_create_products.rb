class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :title
      t.integer :price, null: false, default: 0
      t.references :category, foreign_key: true, null: false

      t.timestamps
    end
  end
end
