require "rails_helper"

RSpec.describe PostsHelper, type: :helper do
  describe "#tags_available?" do
    context "when params[:tags] is not available" do
      subject { helper.tags_available? }
      it { should be nil}
    end

    context "when params[:tags] contains empty item" do
      before { params[:tags] = [""] }
      subject { helper.tags_available? }
      it { should be false}
    end

    context "when params[:tags] empty" do
      before { params[:tags] = [] }
      subject { helper.tags_available? }
      it { should be false}
    end

    context "when params tag valid" do
      before { params[:tags] = ["testing"] }
      subject { helper.tags_available? }
      it { should be true}
    end
  end
  
  describe "#tags_for" do
    context "when post is not available" do
      before { create_list(:tag, 10) }
      subject { helper.tags_for(nil) }
      it { expect(subject.size).to eq(10) }
    end

    context "when post has tags" do
      before do
        tags = create_list(:tag, 3)
      end
      let(:post) do
        create(:post) do |post|
          post.tags.create(attributes_for(:tag))
        end
      end
      subject { helper.tags_for(post) }
      it { expect(subject.size).to eq(3) }
    end
  end

  describe "#get tags" do
    before { @tags_id = create_list(:tag, 4).map {|tag| tag.id } }
    context "when id is invalid" do
      subject { helper.get_tags(["1", "2"]) }
      it { expect(subject.empty?).to be true }
    end

    context "when id is valid" do
      subject { helper.get_tags(@tags_id) }
      it { expect(subject.empty?).to be false }
    end
  end
end
