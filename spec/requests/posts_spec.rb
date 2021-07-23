require "rails_helper"

RSpec.describe "Posts", type: :request do
  def register_and_login_as(user)
    create(user) do |user|
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
        register_and_login_as(:user)
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
        register_and_login_as(:user)
      end
      it { expect{ post(posts_path, params: { post: { 
        content: "test content" }}) }.to change { Post.count }.from(0).to(1) }
      it { should redirect_to root_url }
    end

    context "when tags is not empty" do
      before do
        register_and_login_as(:user)
        @tag = create(:tag)
      end
      it { expect{ post(posts_path, params: { post: { 
        content: "test content" }, tags: [@tag.id] }) }
        .to change { Post.count }.from(0).to(1) }
      it { should redirect_to root_url }
    end
  end

  describe "PATCH update post" do
    context "when not logged in" do
      before do
        post = create(:post)
        patch(posts_path, params: { id: post.id })
      end
      it { expect(flash.empty?).to be false }
      it { should redirect_to login_url }
    end

    context "when not a post owner" do
      before do
        register_and_login_as(:other_user)
        post = create(:post)
        patch(posts_path, params: { id: post.id, post: { 
          content: "new content", 
          tag_ids: "new tagid" } })
      end
      it { expect(flash.empty?).to be false }
      it { should redirect_to root_url }
    end
    
    context "when post not found" do
      before do
        register_and_login_as
        post = create(:post)
        patch(posts_path, params: { id: "wrongid", post: { 
          content: "new content", 
          tag_ids: "new tagid" } })
      end
      it { expect(flash.empty?).to be false }
      it { should redirect_to root_url }
    end

    context "when updatable" do
      before do
        register_and_login_as
        @post = create(:post)
        @tag = create(:tag)
        patch(posts_path, params: { id: @post.id, post: { 
          content: "new content", 
          tag_ids: [@tag.id] } })
      end
      it { expect(@post.reload.content).to eql?("new content") }
      it { expect(@post.reload.tags.size).to eq(1) }
      it { expect(flash.empty?).to be false }
      it { should redirect_to root_url }
    end
  end

  describe "DELETE destroy a post" do
    context "when not logged in" do
      before do
        post = create(:post)
        delete(post_path(id: post.id))
      end
      it { expect(flash.empty?).to be false }
      it { should redirect_to login_url }
    end

    context "when not a post owner" do
      before do
        register_and_login_as(:other_user)
        post = create(:post)
        delete(post_path(id: post.id))
      end
      it { expect(flash.empty?).to be false }
      it { should redirect_to login_url }
    end

    context "when post not found" do
      before do
        register_and_login_as(:user)
        post = create(:post)
        delete(post_path(id: post.id))
      end
      it { expect(flash.empty?).to be false }
      it { should redirect_to root_url }
    end
    context "when deletable" do
      before do
        register_and_login_as(:user)
        @post = create(:post)
      end
      it { expect{ delete(post_path(id: @post.id)) }.to change{ 
          Post.count }.by(-1) }
      it { should redirect_to root_url }
    end
  end
end
