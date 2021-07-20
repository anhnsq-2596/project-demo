require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /register" do
    before { get "/register" }
    it { expect(response).to have_http_status(:success) }
    it { should render_template("users/new") }
  end
  
  describe "POST /users" do
    subject { post "/users", params: { user: attributes_for(:user) } }
    it "should create new user and render home page" do
      should redirect_to root_url
      expect{ post "/users", params: {
        user: attributes_for(:user, email: "newemail@example.com")
        }
      }.to change{ User.count }.from(1).to(2)
    end
  end
end
