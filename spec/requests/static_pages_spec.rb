require "rails_helper"
require 'dotenv'

RSpec.describe "StaticPages", type: :request do
  describe "GET /" do
    context "when no post" do
      before { get root_path }
      it { expect(response).to have_http_status(:success) }
      it { should render_template("static_pages/home") }
      it { expect(assigns(:posts).to_a.empty?).to be true }
    end
    
    context "when post available" do
      before do
        create(:post)
        get root_path
      end
      it { expect(response).to have_http_status(:success) }
      it { should render_template("static_pages/home") }
      it { expect(assigns(:posts).to_a.empty?).to be false }
    end

    context "when paginated" do
      before do
        @per_page = ENV['DEFAULT_RECORD_PER_PAGE'].to_i
        user = create(:user)
        create_list(:post, @per_page + 1, user: user)
        get root_path
      end
      it { expect(response).to have_http_status(:success) }
      it { should render_template("static_pages/home") }
      it { expect(assigns(:posts).to_a.size).to be(@per_page) }
    end
    
  end

  describe "GET /about" do
    before { get about_path }
    it { expect(response).to have_http_status(:success) }
    it { should render_template("static_pages/about") }
  end
end
