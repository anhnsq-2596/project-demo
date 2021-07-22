require "rails_helper"

RSpec.describe Tag, type: :model do
  subject { build(:tag) }
  it { should validate_presence_of(:label) }
  it { is_expected.to validate_length_of(:label).is_at_least(3) }
  it { is_expected.to validate_length_of(:label).is_at_most(30) }
  it { should validate_uniqueness_of(:label) }
end
