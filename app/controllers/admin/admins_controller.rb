class Admin::AdminsController < AdminController
  def toggle_accepting_orders
    Current.admin.update!(params.expect(admin: [:accepting_orders]))
  end
end
