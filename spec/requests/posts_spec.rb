require "rails_helper"

RSpec.describe "Posts", type: :request do
  def register_and_login
    create(:user) do |user|
      post "/login", params: {
        session: {
          email: user.email,
          password: user.password
        }
      }
    end
  end
  
  describe "GET /show" do
    subject { create(:post) }
    before { get post_path(id: subject.id) }
    it { expect(response).to have_http_status(:success) }
    it { should render_template("posts/show") }
  end

  describe "GET /new" do
    context "when not logged in" do
      before { get new_post_path }
      it { redirect_to login_url }
      it { expect(flash.empty?).to be false }
    end

    context "when logged in" do
      before do
        register_and_login
        get new_post_path
      end
      it { should render_template("posts/new") }
    end
  end

  describe "POST create a post" do
    context "when not logged in" do
      before { post posts_path }
      it { redirect_to login_url }
      it { expect(flash.empty?).to be false }
    end

    context "when tags is empty" do
      before do
        register_and_login
      end
      it { expect{ post(posts_path, params: { post: { 
        content: "test content" }}) }.to change { Post.count }.from(0).to(1) }
      it { should redirect_to root_url }
    end

    context "when tags is not empty" do
      before do
        register_and_login
        @tag = create(:tag)
      end
      it { expect{ post(posts_path, params: { post: { 
        content: "test content" }, tags: [@tag.id] }) }
        .to change { Post.count }.from(0).to(1) }
      it { should redirect_to root_url }
    end
  end
end
