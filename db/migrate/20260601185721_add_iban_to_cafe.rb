class AddIbanToCafe < ActiveRecord::Migration[8.0]
  def change
    add_column :cafes, :iban, :string
  end
end
