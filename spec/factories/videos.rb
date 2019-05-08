FactoryBot.define do
  factory :video do
    title { Faker::Pokemon.name }
    description { Faker::SiliconValley.motto }
    video_id { Faker::Crypto.md5 }
    tutorial
  end

  factory :sequenced_video, parent: :video do
    sequence(:position){ |n| n}
  end
end
