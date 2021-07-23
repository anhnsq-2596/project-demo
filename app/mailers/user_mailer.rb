class UserMailer < ApplicationMailer
  def password_reset(user, locale)
    @user = user
    I18n.with_locale(locale) do
      mail(to: @user.email, subject: t("password_resets.mail.subject"))
    end
  end
end
