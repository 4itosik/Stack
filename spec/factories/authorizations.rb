FactoryGirl.define do
  factory :authorization do
    provider "facebook"
    uid "12312312312"

    factory :confirmed do
      association :user
      confirmation true
    end

    factory :non_confirmed do
      confirmation false
      email "test@test.ru"
      confirmation_token "12345678"
    end
  end
end
