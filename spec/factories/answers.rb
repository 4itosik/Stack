FactoryGirl.define do
  factory :answer do
    body "Test big body for answer for question"
    association :question
    association :user

    factory :best do
      best true
    end
  end

  factory :invalid_answer, class: "Answer" do
    body nil
  end
end