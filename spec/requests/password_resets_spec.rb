require 'rails_helper'

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
        post("/password_resets", params: { password_reset: {
          email: "asdfa@gmail.com" }})
      end
      it { expect(flash.empty?).to_not be true }
      it { should render_template("password_reset/new") }
    end

    context "when email is valid" do
      before do
        user = create(:user)
        post("/password_resets", params: { password_reset: {
          email: user.email }})
      end
      it { expect(flash.empty?).to_not be true }
      it { should redirect_to login_url }
    end
  end
  

  describe "GET to edit page" do
    context "when email is invalid" do
      
    end

    context "when email is valid" do
      
    end
    
    context "when token is invalid" do
      
    end

    context "when token is valid" do
      
    end
  end
  
  describe "PATCH edit password" do
    context "when email is invalid" do
      
    end

    context "when email is valid" do
      
    end

    context "when password is invalid" do
      
    end

    context "when password is valid" do
      
    end
    
  end

end
