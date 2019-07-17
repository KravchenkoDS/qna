FactoryBot.define do

  sequence :email do |n|
    "user#{n}@domain.com"
  end

  factory :user do
    email
    password {'5454545'}
    password_confirmation {'5454545'}
  end
end
