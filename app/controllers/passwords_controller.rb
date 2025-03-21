class PasswordsController < ApplicationController
  before_action :set_admin_by_token, only: %i[ edit update ]

  def new
  end

  def create
    if admin = Admin.find_by(name: params[:name])
      PasswordsMailer.reset(admin).deliver_later
    end

    redirect_to admin_url, notice: "Password reset instructions sent (if admin with that email address exists)."
  end

  def edit
  end

  def update
    if @admin.update(params.permit(:password, :password_confirmation))
      redirect_to admin_url, notice: "Password has been reset."
    else
      redirect_to edit_password_url(params[:token]), alert: "Passwords did not match."
    end
  end

  private
    def set_admin_by_token
      @admin = Admin.find_by_password_reset_token!(params[:token])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to new_password_url, alert: "Password reset link is invalid or has expired."
    end
end
