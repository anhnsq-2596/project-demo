require "rails_helper"
require "dotenv" if (ENV["RUBY_ENV"] == "development" || 
  ENV["RUBY_ENV"] == "test")

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

    context "when search param available" do
      before do
        user = create(:user)
        post1 = create(:post, user: user)
        post2 = create(:post_with_long_content, user: user)
        get(root_path, params: { search: "hello welcome" })
      end
      it { expect(response).to have_http_status(:success) }
      it { should render_template("static_pages/home") }
      it { expect(assigns(:posts).to_a.size).to eq(1) }
    end
    
    context "when search param not match" do
      before do
        user = create(:user)
        post1 = create(:post, user: user)
        post2 = create(:post_with_long_content, user: user)
        get(root_path, params: { search: "nguyensyquanganh" })
      end
      it { expect(response).to have_http_status(:success) }
      it { should render_template("static_pages/home") }
      it { expect(assigns(:posts).to_a.empty?).to be true }
    end
    
    context "when filter param not match" do
      before do
        user = create(:user)
        tags = create_list(:tag, 4)
        post1 = create(:post, user: user, tags: tags[0..1])
        post2 = create(:post_with_long_content, user: user, tags: tags[1..2])
        get(root_path, params: { filter: "sdafsd" })
      end
      it { expect(response).to have_http_status(:success) }
      it { should render_template("static_pages/home") }
      it { expect(assigns(:posts).to_a.empty?).to be true }
    end

    context "when paginated" do
      before do
        @per_page = ENV["DEFAULT_RECORD_PER_PAGE"].to_i
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
