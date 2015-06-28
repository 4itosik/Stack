FactoryGirl.define do
  factory :question do
    title "Test string 15 length"
    body "Test body Test body Test body "
    association :user
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
end