require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "password_reset" do
    before do
      @user = create(:user)
      @user.create_reset_digest
    end
    let(:mail) { UserMailer.password_reset(@user, "en") }

    it "renders the headers" do
      expect(mail.subject).to eq("Password Reset")
      expect(mail.to).to eq([@user.email])
      expect(mail.from).to eq(["no-reply@example.com"])
    end
  end
end
