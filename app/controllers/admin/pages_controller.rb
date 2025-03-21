class Admin::PagesController < AdminController
  allow_unauthenticated_access only: :login

  def login
    render layout: 'application'
  end

  def account
  end
end
