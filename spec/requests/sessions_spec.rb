require "rails_helper"

RSpec.describe "Sessions", type: :request do
  def register_and_login(email, password)
    create(:user) do |user|
      post "/login", params: {
        session: {
          email: email || user.email,
          password: password || user.password
        }
      }
    end
  end
  describe "GET /login" do
    before { get "/login" }
    it { expect(response).to have_http_status(:success) }
    it { assert_template("sessions/new") }
  end
  
  describe "POST /login" do
    context "with authenticated credentials" do
      before { register_and_login(nil, nil) }
      it { assert_redirected_to root_url }
      it { expect(session[:user_id]).to_not be_nil }
    end
    
    context "with wrong email" do
      before { register_and_login("test@example.com", nil) }
      it { should render_template("sessions/new") }
      it { expect(session[:user_id]).to be_nil }
    end
    
    context "with wrong password" do
      before { register_and_login(nil, "222222") }
      it { should render_template("sessions/new") }
      it { expect(session[:user_id]).to be_nil }
    end
  end

  describe "DELETE /logout" do
    context "when logged in" do
      before do
        register_and_login(nil, nil)
        delete "/logout"
      end
      it { assert_redirected_to login_url }
      it { expect(session[:user_id]).to be_nil }
    end
    
    context "when not logged in" do
      before { delete "/logout" }
      it { assert_redirected_to login_url }
      it { expect(session[:user_id]).to be_nil }
    end
  end
end
