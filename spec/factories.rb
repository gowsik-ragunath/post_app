FactoryBot.define do
  factory :user_comment_rating do
    user { nil }
    comment { nil }
    rating { 1 }
  end
  factory :user do
    email { 'test@example.com' }
    password { 'f4k3p455w0rd' }
  end
end