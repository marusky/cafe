class PasswordsMailer < ApplicationMailer
  def reset(admin)
    @admin = admin
    mail subject: "Reset your password", to: admin.name
  end
end
