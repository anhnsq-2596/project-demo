require 'rails_helper'

RSpec.describe User, type: :model do
  it "should have email address" do
    user = User.new(
      email: "",
      name: "Test",
      password: "111111",
      password_confirmation: "111111"
    )
    expect(user.save).to be false  
  end

  it "should have name" do
    user = User.new(
      email: "test@example.com",
      name: "",
      password: "111111",
      password_confirmation: "111111"
    )
    expect(user.save).to be false
  end

  it "should have unique email address" do
    user1 = User.new(
      email: "test@test.com",
      name: "Test",
      password: "111111",
      password_confirmation: "111111"
    )
    user1.save
    user2 = User.new(
      email: "test@test.com",
      name: "Test2",
      password: "111111",
      password_confirmation: "111111"
    )
    expect(user2.save).to be false
  end
  
  it "should not have invalid email format" do
    user = User.new(
      email: "test@example123",
      name: "Name",
      password: "111111",
      password_confirmation: "111111"
    )
    expect(user.save).to be false
  end

  it "should have valid password with length >= 6" do
    user = User.new(
      email: "test@example.com",
      name: "Name",
      password: "11111",
      password_confirmation: "111111"
    )
    expect(user.save).to be false
  end

  it "should have retype password match" do
    user = User.new(
      email: "test@example.com",
      name: "Name",
      password: "111111",
      password_confirmation: "111112"
    )
    expect(user.save).to be false
  end

  it "should have not empty password" do
    user = User.new(
      email: "test@example.com",
      name: "Name",
      password: "",
      password_confirmation: "111112"
    )
    expect(user.save).to be false
  end
  
  it "should have not blank password" do
    user = User.new(
      email: "test@example.com",
      name: "Name",
      password: "      ",
      password_confirmation: "111112"
    )
    expect(user.save).to be false
  end

  it "should be valid" do
    user = User.new(
      email: "test345@example.com",
      name: "Name",
      password: "111111",
      password_confirmation: "111111"
    )
    expect(user.save).to be true
  end

end
