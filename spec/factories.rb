FactoryGirl.define do
  factory :user do
    username "pusheen"
    email "pusheen@kittybloggens.com"
    password "tostij"
    password_confirmation "tostij"
    uid "88888"
  end

  factory :location do
    node_number 34
    node_id "432934"
    latitude 52.08254
    longitude 5.03694
  end
end
