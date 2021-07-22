require "rails_helper"

RSpec.describe Post, type: :model do
  describe "validations" do
    subject { build(:post) }
    it { should validate_presence_of(:content) }
  end
end
