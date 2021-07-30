require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "GET /register" do
    before { get "/register" }
    it { expect(response).to have_http_status(:success) }
    it { should render_template("users/new") }
  end
  
  describe "POST /users" do
    it "should create new user and render login page" do
      expect{ post "/users", params: {
        user: attributes_for(:user) } }.to change{ User.count }.by(1)
      should redirect_to login_url
    end
  end

  describe "GET /user/:id" do
    context "when no post" do
      before { get user_url(id: create(:user)) }
      it { expect(response).to have_http_status(:success) }
      it { should render_template("users/show") }
      it { expect(assigns(:posts).to_a.empty?).to be true }
    end
    
    context "when post available" do
      before do
        user = create(:user)
        create(:post, user: user)
        get user_url(id: user.id)
      end
      it { expect(response).to have_http_status(:success) }
      it { should render_template("users/show") }
      it { expect(assigns(:posts).to_a.empty?).to be false }
    end

    context "when search param available" do
      before do
        user = create(:user)
        post1 = create(:post, user: user)
        post2 = create(:post_with_long_content, user: user)
        get(user_url(id: user.id), params: { search: "hello welcome" })
      end
      it { expect(response).to have_http_status(:success) }
      it { should render_template("users/show") }
      it { expect(assigns(:posts).to_a.size).to eq(1) }
    end
    
    context "when search param not match" do
      before do
        user = create(:user)
        post1 = create(:post, user: user)
        post2 = create(:post_with_long_content, user: user)
        get(user_url(id: user.id), params: { search: "nguyensyquanganh" })
      end
      it { expect(response).to have_http_status(:success) }
      it { should render_template("users/show") }
      it { expect(assigns(:posts).to_a.empty?).to be true }
    end
    
    context "when filter param not match" do
      before do
        user = create(:user)
        tags = create_list(:tag, 4)
        post1 = create(:post, user: user, tags: tags[0..1])
        post2 = create(:post_with_long_content, user: user, tags: tags[1..2])
        get(user_url(id: user.id), params: { filter: "sdafsd" })
      end
      it { expect(response).to have_http_status(:success) }
      it { should render_template("users/show") }
      it { expect(assigns(:posts).to_a.empty?).to be true }
    end

    context "when paginated" do
      before do
        @per_page = ENV["DEFAULT_RECORD_PER_PAGE"].to_i
        user = create(:user)
        create_list(:post, @per_page + 1, user: user)
        get user_url(id: user.id)
      end
      it { expect(response).to have_http_status(:success) }
      it { should render_template("users/show") }
      it { expect(assigns(:posts).to_a.size).to be(@per_page) }
    end  
  end
end
