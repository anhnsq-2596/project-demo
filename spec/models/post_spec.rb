require "rails_helper"

RSpec.describe Post, type: :model do
  describe "validations" do
    subject { create(:post) }
    it { should validate_presence_of(:content) }
    it { is_expected.to validate_length_of(:content).is_at_most(250) }
    it { is_expected.to have_and_belong_to_many(:tags) }
    it { is_expected.to belong_to(:user) }
  end
  
  describe "#local_created_at" do
    subject { create(:post) }
    it { expect(subject.local_created_at).to be 
      eq(subject.created_at.localtime.strftime("%H:%M:%S - %d/%m/%Y")) }
  end
end
