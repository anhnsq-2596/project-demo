FactoryBot.define do
  factory :tag do
    label { "test code" }
  end

  factory :user do
    name { "Test" }
    email { "myemail@example.com" }
    password { "111111" }
    password_confirmation { "111111" }

    trait :invalid_email do
      email {"myemail@wrong"}
    end

    trait :too_short_password do
      password { "11111" }
    end

    trait :password_not_match do
      password { "111111" }
      password_confirmation { "111112" }
    end

    trait :different_email do
      email { "myemail2@example.com" }
    end

    factory :user_with_invalid_email, traits: [:invalid_email]
    factory :user_with_too_short_password, traits: [:too_short_password]
    factory :user_with_not_matched_password, traits: [:password_not_match]
    factory :other_user, traits: [:different_email]
  end

  factory :post do
    content { "this is a test content" }
    user
  end
end

def user_with_posts(posts_count: 5)
  FactoryBot.create(:user) do |user|
    FactoryBot.create_list(:post, posts_count, user: user)
  end
end

def post_with_tags(tags_count: 2)
  FactoryBot.create(:post) do |post|
    FactoryBot.create_list(:tag, tags_count, posts: [post])
  end
end
