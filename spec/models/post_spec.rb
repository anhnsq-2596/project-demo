require "rails_helper"

RSpec.describe Post, type: :model do
  describe "validations" do
    subject { create(:post) }
    it { should validate_presence_of(:content) }
    it { is_expected.to validate_length_of(:content).is_at_most(250) }
    it { is_expected.to have_and_belong_to_many(:tags) }
    it { is_expected.to belong_to(:user) }
  end
  
  describe "#get_tags" do
    before { @post = build(:post) }
    subject { ["60f7a3ec32dbbabcab7f7cd2"] }
    it { expect{ @post.get_tags subject }.to change{ @post.tag_ids } }
  end
end
