class AddPayeeNameToCafes < ActiveRecord::Migration[8.0]
  def change
    add_column :cafes, :payee, :string
  end
end
