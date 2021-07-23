require "rails_helper"

RSpec.describe "Tags", type: :request do
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

  describe "GET /new" do
    context "when not logged in" do
      before { get new_tag_path }
      it { redirect_to login_url }
      it { expect(flash.empty?).to be false }
    end

    context "when logged in" do
      before do
        register_and_login
        get new_tag_path
      end
      it { should render_template("tags/new") }
    end
  end

  describe "POST create a tag" do
    context "when not logged in" do
      before { post tags_path }
      it { redirect_to login_url }
      it { expect(flash.empty?).to be false }
    end

    context "when logged in" do
      before { register_and_login }
      it { expect{ post(tags_path, params: { tag: { label: "testlabel" } }) }
      .to change{ Tag.count }.by(1) }
      it { should redirect_to new_tag_url }
    end
  end
end
