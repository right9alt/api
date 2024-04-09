class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def welcome_email(user)
    @user = user
    @url  = 'http://example.com/login' # Замените на URL вашего веб-приложения
    mail(to: @user.email, subject: 'Добро пожаловать на сайт')
  end

  def reset_password_code
    @user = params[:user]
    @reset_code = params[:reset_code]
    mail(to: @user.email, subject: "Код сброса пароля")
  end

end