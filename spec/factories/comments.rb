FactoryGirl.define do
  factory :comment do
    body "Test big body for answer for question"
    association :user
    association :commentable, factory: :question
  end

  factory :invalid_comment, class: "Comment" do
    body nil
  end
end