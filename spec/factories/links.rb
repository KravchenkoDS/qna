FactoryBot.define do
  factory :link do
    name { "MyString" }
    url { "https://github.com" }

    trait :for_question do
      linkable { create(:question, author: create(:user)) }
    end

    trait :with_invalid_url do
      url { 'http:/error_url' }
    end
  end
end
