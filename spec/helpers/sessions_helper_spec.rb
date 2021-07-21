require "rails_helper"

RSpec.describe SessionsHelper, type: :helper do
  def register_and_log_in
    user = create(:user)
    session[:user_id] = user.id
  end
  
  describe "#current_user" do
    context "when logged in" do
      before { register_and_log_in }
      
      it { expect(helper.current_user).to_not be_nil }
    end

    context "when not logged in" do
      it { expect(helper.current_user).to be_nil }
    end
  end

  describe "#logged_in?" do
    context "when logged in" do
      before { register_and_log_in }
      
      it { expect(helper.logged_in?).to be true }
    end

    context "when not logged in" do
      it { expect(helper.logged_in?).to be false }
    end
  end

  describe "#log_out" do
    context "when logged in" do
      before { register_and_log_in; helper.log_out }
      it { expect(session[:user_id]).to be_nil }
    end

    context "when not logged in" do
      before do
        session[:user_id] = "test"
        helper.log_out
      end
      it { expect(session[:user_id]).to eq("test") }
    end
  end
end
