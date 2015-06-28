FactoryGirl.define do
  factory :vote do
    like 1
    association :user
    association :voteable, factory: :question
  end
end