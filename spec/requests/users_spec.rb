require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "GET /register" do
    before { get "/register" }
    it { expect(response).to have_http_status(:success) }
    it { should render_template("users/new") }
  end
  
  describe "POST /users" do
    it "should create new user and render home page" do
      expect{ post "/users", params: {
        user: attributes_for(:user)
        }
      }.to change{ User.count }.by(1)
      should redirect_to root_url
    end
  end
end
