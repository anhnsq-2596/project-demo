require "rails_helper"

RSpec.describe Post, type: :model do
  describe "validations" do
    subject { create(:post) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:content) }
    it { is_expected.to validate_length_of(:title).is_at_most(100) }
    it { is_expected.to validate_length_of(:content).is_at_most(250) }
    it { is_expected.to have_and_belong_to_many(:tags) }
    it { is_expected.to belong_to(:user) }
  end
  
  describe "#local_created_at" do
    subject { create(:post) }
    it { expect(subject.local_created_at)
      .to eq(subject.created_at.localtime.strftime("%H:%M:%S - %d/%m/%Y")) }
  end

  describe "#description with > 10 words content" do
    subject { create(:post_with_long_content) }
    it { expect(subject.description)
      .to eq(subject.content.split.slice(...10).join(" ") << "...") }
  end

  describe "#description with <= 10 words content" do
    subject { create(:post) }
    it { expect(subject.description)
      .to eq(subject.content) }
  end
end
