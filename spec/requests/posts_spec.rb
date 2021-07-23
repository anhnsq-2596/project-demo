require "rails_helper"

RSpec.describe "Posts", type: :request do
  def register_and_log_in_as(user)
    create(user) do |user|
      post "/login", params: {
        session: {
          email: user.email,
          password: user.password
        }
      }
    end
  end

  def log_in_as(user)
    post "/login", params: {
      session: {
        email: user.email,
        password: user.password
      }
    }
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
        register_and_log_in_as(:user)
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
        register_and_log_in_as(:user)
      end
      it { expect{ post(posts_path, params: { post: { 
        content: "test content" }}) }.to change { Post.count }.from(0).to(1) }
      it { should redirect_to root_url }
    end

    context "when tags is not empty" do
      before do
        register_and_log_in_as(:user)
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
        patch(post_path(id: post.id))
      end
      it { expect(flash.empty?).to be false }
      it { should redirect_to login_url }
    end

    context "when not a post owner" do
      before do
        post = create(:post)
        other = create(:other_user)
        log_in_as(other)
        patch(post_path(id: post.id), params: { post: { 
          content: "new content", 
          tag_ids: "new tagid" } })
      end
      it { expect(flash.empty?).to be false }
      it { should redirect_to root_url }
    end
    
    context "when post not found" do
      before do
        post = create(:post)
        log_in_as(post.user)
        patch(post_path(id: "wrongid"), params: { post: { 
          content: "new content", 
          tag_ids: "new tagid" } })
      end
      it { expect(flash.empty?).to be false }
      it { should redirect_to root_url }
    end

    context "when updatable" do
      before do
        @post = create(:post)
        log_in_as(@post.user)
        tag = create(:tag)
        patch(post_path(id: @post.id), params: { "tags[]": tag.id.to_s, post: { 
          content: "new content" } })
      end
      it { expect(@post.reload.content).to eq("new content") }
      it { expect(@post.reload.tag_ids.size).to eq(1) }
      it { expect(flash.empty?).to be false }
      it { should redirect_to post_path(@post) }
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
        post = create(:post)
        other = create(:other_user)
        log_in_as(other)
        delete(post_path(id: post.id))
      end
      it { expect(flash.empty?).to be false }
      it { should redirect_to root_url }
    end

    context "when post not found" do
      before do
        post = create(:post)
        log_in_as(post.user)
        delete(post_path(id: post.id))
      end
      it { expect(flash.empty?).to be false }
      it { should redirect_to root_url }
    end
    context "when deletable" do
      before do
        @post = create(:post)
        log_in_as(@post.user)
      end
      it { expect{ delete(post_path(id: @post.id)) }.to change{ 
          Post.count }.by(-1) }
      it { should redirect_to root_url }
    end
  end
end
