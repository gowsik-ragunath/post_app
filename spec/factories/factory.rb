FactoryBot.define do
  factory :user do
    email { 'user@test.com' }
    password { 'password' }
    admin { false }
  end

  factory :topic do
    name { 'topic_name' }
  end

  factory :tag do
    tag { 'sample' }
  end

  factory :post do
    title { 'post_title' }
    body { 'body_of_post_title' }
  end

  factory :comment do
    body { 'body of the comment' }
  end

  factory :rating do
    rating { 5 }
    trait :rating4 do
      rating { 4 }
    end
  end
end