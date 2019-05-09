FactoryBot.define do
  factory :video do
    title { Faker::Pokemon.name }
    description { Faker::SiliconValley.motto }
    video_id { Faker::Crypto.md5 }
    thumbnail { 'https://media.licdn.com/dms/image/C560BAQFWOfDVm7nHeg/company-logo_200_200/0?e=2159024400&v=beta&t=L7yzPfsyYeZUjkJc1Abfwbg-Nx710fAvwEYbf02LIEE' }
    tutorial
  end

  factory :sequenced_video, parent: :video do
    sequence(:position){ |n| n }
  end
end
