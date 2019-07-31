FactoryBot.define do
  factory :award do
    sequence :title do |n|
      "MyTextAward#{n}"
    end

    image { fixture_file_upload(Rails.root.join('tmp/images', 'images.jpeg'), 'images.jpeg') }

    trait :for_question do
      question { create(:question, author: create(:user)) }
    end
  end
end
