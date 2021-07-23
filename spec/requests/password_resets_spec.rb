require "rails_helper"

RSpec.describe "PasswordResets", type: :request do
  describe "GET /new" do
    before { get new_password_reset_path }
    id { should have_http_status(:success) }
    it { should render_template("password_resets/new") }
  end

  describe "POST send email and create reset digest" do
    context "when email is invalid" do
      before do
        user = create(:user)
        post(password_resets_path, params: { password_reset: {
          email: "asdfa@gmail.com" }})
      end
      it { expect(flash.empty?).to_not be true }
      it { should render_template("password_reset/new") }
    end

    context "when email is valid" do
      before do
        user = create(:user)
        post(password_resets_path, params: { password_reset: {
          email: user.email }})
      end
      it { expect(flash.empty?).to_not be true }
      it { should redirect_to login_url }
    end
  end

  describe "GET to edit page" do
    context "when email is invalid" do
      before do
        @user =create(:user)
        @user.create_reset_digest
        get(edit_password_reset_url(id: @user.reset_token))
      end
      it { should redirect_to login_url }
    end

    context "when token is invalid" do
      before do
        @user = create(:user)
        @user.create_reset_digest
        @my_cookies.signed[:user_email] = @user.email
        cookies[:user_email] = @my_cookies[:user_email]
        get(edit_password_reset_url(id: "wrongtoken"))
      end
      it { should redirect_to login_url }
    end

    context "when token is valid" do
      before do
        @user = create(:user)
        @user.create_reset_digest
        get(edit_password_reset_url(id: @user.reset_token, email: @user.email))
      end
      it { should render_template("password_resets/edit") }
    end
  end
  
  describe "PATCH edit password" do
    context "when email is invalid" do
      before do
        @user = create(:user)
        @pw = @user.password_digest
        @user.create_reset_digest
        patch password_reset_url(id: @user.reset_token)
      end

      it { should render_template("password_resets/edit") }
      it { expect(@pw).to eql(@user.password_digest) }
    end

    context "when password is invalid" do
      before do
        @user = create(:user)
        @pw = @user.password_digest
        @user.create_reset_digest
        patch(password_reset_url(id: @user.reset_token, email: @user.email),
          params: { user: { password: "12312",
            password_confirmation: "12312" }
          })
      end

      it { should render_template("password_resets/edit") }
      it { expect(@pw).to eql(@user.password_digest) }
    end

    context "when password is valid" do
      before do
        @user = create(:user)
        @pw = @user.password_digest
        @user.create_reset_digest
        patch(password_reset_url(id: @user.reset_token, email: @user.email),
          params: { user: { password: "123123",
            password_confirmation: "123123" }
          })
      end

      it { should redirect_to login_url }
      it { expect(flash.empty?).to be false } 
      it { expect(@pw).not_to eql(@user.reload.password_digest) }
    end
  end
end
