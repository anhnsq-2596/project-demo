require "rails_helper"

RSpec.describe "StaticPages", type: :request do
  describe "GET /" do
    before { get "/" }
    it { expect(response).to have_http_status(:success) }
    it { should render_template("static_pages/home") }
  end

  describe "GET /about" do
    before { get "/about" }
    it { expect(response).to have_http_status(:success) }
    it { should render_template("static_pages/about") }
  end
end
