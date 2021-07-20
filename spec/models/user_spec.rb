require "rails_helper"

RSpec.describe User, type: :model do
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
    user.destroy
  end
end
