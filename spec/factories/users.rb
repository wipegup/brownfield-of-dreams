FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    first_name { Faker::Dog.name }
    last_name { Faker::Artist.name }
    password { Faker::Color.color_name }
    github_uid { nil }
    github_token { nil }
    role { :default }
  end

  factory :admin, parent: :user do
    role { :admin }
  end

  factory :github_user, parent: :user do
    sequence(:github_uid){ |n| n }
    sequence(:github_token){ |n| n }
  end
end
