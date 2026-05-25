class Admin::CafesController < AdminController
  def toggle_open_cafe
    Current.cafe.update!(params.expect(cafe: [:open]))
  end
end
