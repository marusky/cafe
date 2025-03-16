class SessionsController < AdminController
  allow_unauthenticated_access only: :create
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def create
    if admin = Admin.authenticate_by(params.permit(:name, :password))
      start_new_session_for admin
      redirect_to categories_url
    else
      redirect_to admin_url, alert: "Try another email address or password."
    end
  end

  def destroy
    terminate_session
    redirect_to admin_url
  end
end
