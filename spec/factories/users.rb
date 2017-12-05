FactoryBot.define do
  factory :user do
    name "hoge"
    email "hoge@example.com"

    trait :invalid do
      name nil
    end
  end

  factory :takashi, class: User do
    name "Takashi"
    email "takashi@example.com"
  end

  factory :satoshi, class: User do
    name "Satoshi"
    email "satoshi@example.com"
  end
end
