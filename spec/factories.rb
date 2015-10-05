FactoryGirl.define do
  factory :user do
    username "pusheen"
    email "pusheen@kittybloggens.com"
    password "tosti"
    password_confirmation "tosti"
  end

  factory :location do
    node_number 34
    latitude 52.08254
    longitude 5.03694
  end
end
