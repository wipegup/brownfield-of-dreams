FactoryBot.define do
  factory :activation do
    user
    status { false }
    email_code { '123' }
  end
end
