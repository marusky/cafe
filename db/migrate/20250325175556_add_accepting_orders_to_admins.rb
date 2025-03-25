class AddAcceptingOrdersToAdmins < ActiveRecord::Migration[8.0]
  def change
    add_column :admins, :accepting_orders, :boolean
  end
end
