class Admin::PagesController < AdminController
  allow_unauthenticated_access only: :login

  def login
  end

  def settings
  end
end
