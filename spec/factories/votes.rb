FactoryBot.define do
  factory :vote do
    value { 1 }
    user
  end

  trait :for_question do
    association(:votable, factory: :question)
  end
end
