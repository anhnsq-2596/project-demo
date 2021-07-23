require "rails_helper"

RSpec.describe User, type: :model do
  def register
    create(:user)
  end
  context "validations" do
    subject { build(:user) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should have_secure_password(:password) }

    subject { build(:user_with_invalid_email) }
    it { is_expected.to_not be_valid }
    
    subject { build(:user_with_too_short_password) }
    it { is_expected.to_not be_valid }

    subject { build(:user_with_not_matched_password) }
    it { is_expected.to_not be_valid }
  end

  it "should downcase email before saving" do
    user = create(:user, email: "tESt23@example.com")
    expect(user.email).to include("test23")
  end

  describe "#authenticated?" do
    context "when login with correct password" do
      subject { register }
      let(:pw) { "111111" }
      it { expect(subject.authenticated?(pw)).to be true }
    end
    context "when login with incorrect password" do
      subject { register }
      let(:pw) { "111112" }
      it { expect(subject.authenticated?(pw)).to be false }
    end
  end

  describe "#create_reset_digest" do
    before do
      @user = create(:user)
      @user.create_reset_digest
    end
    
    it { expect(@user.reset_digest).to_not be_nil }
  end
  
  describe "#validated?" do
    context "when reset_digest is nil" do
      before { @user = create(:user) }
      let(:token) { "test" }
      it { expect(@user.validated?(token)).to be false }
    end
    
    context "when token is valid" do
      let(:token) { User.new_token }
      before do
        @user = create(:user)
        @user.update_attribute(:reset_digest, User.digest(token))
      end

      it { expect(@user.validated?(token)).to be true }
    end
    
    context "when token is invalid" do
      let(:token) { User.new_token }
      before do
        @user = create(:user)
        @user.update_attribute(:reset_digest, User.digest(token))
      end

      it { expect(@user.validated?(User.new_token)).to be false }
    end
    
  end
  
  
end
