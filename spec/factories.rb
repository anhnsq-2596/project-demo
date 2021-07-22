FactoryBot.define do
  factory :tag do
    code { "test code" }
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

    factory :user_with_invalid_email, traits: [:invalid_email]
    factory :user_with_too_short_password, traits: [:too_short_password]
    factory :user_with_not_matched_password, traits: [:password_not_match]

    factory :post do
      content { "this is a test content" }
    end
  end

  factory :post_tag, parent: :post do |f|
    f.after_build do |p|
      p.tags << build(:tag)
    end
  end
end
