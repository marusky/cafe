class CreateCafes < ActiveRecord::Migration[8.0]
  def change
    create_table :cafes do |t|
      t.string :name, null: false
      t.string :password_digest, null: false
      t.boolean :open, null: false, default: true

      t.timestamps
    end
  end
end
