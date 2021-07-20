require 'rails_helper'

RSpec.describe User, type: :model do
  it "should have email address" do
    user = User.new(email: "", name: "Test")
    expect(user.save).to be false  
  end

  it "should have name" do
    user = User.new(email: "test@example.com", name: "")
    expect(user.save).to be false
  end

  it "should have unique email address" do
    user1 = User.new(email: "test@test.com", name: "Test")
    user1.save
    user2 = User.new(email: "test@test.com", name: "Test2")
    expect(user2.save).to be false
  end
  
  it "should not have invalid email" do
    user = User.new(email: "test@example123", name: "Name")
    expect(user.save).to be false
  end

  it "should have a valid name and email" do
    user = User.new(email: "test@example.com", name: "Name")
    expect(user.save).to be true
  end

end
