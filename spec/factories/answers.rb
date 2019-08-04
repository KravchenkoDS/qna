FactoryBot.define do
  sequence :body do |n|
    "MyText#{n}"
  end
  factory :answer do
    body
    question
    user

    trait :with_file do
      files { fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'rails_helper.rb') }
    end

    trait :invalid do
      body { nil }
    end
  end
end

