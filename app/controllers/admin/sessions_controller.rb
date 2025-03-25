class Admin::SessionsController < AdminController
  allow_unauthenticated_access only: :create
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to team_login_url, alert: "Try again later." }

  def create
    if admin = Admin.authenticate_by(params.permit(:name, :password))
      start_new_session_for admin
      redirect_to orders_url
    else
      redirect_to team_login_url, alert: "Nesprávne meno alebo heslo."
    end
  end

  def destroy
    terminate_session
    redirect_to team_login_url
  end
end
