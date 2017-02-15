
FactoryGirl.define do
  factory :user do
    name 'Dave Doolin'
    email 'david.doolin2@gmail.com'
    password 'foobar'
    password_confirmation 'foobar'
  end

  sequence :email do |n|
    "person-#{n}@example.com"
  end

  factory :micropost do
    content 'Foo bar'
    association :user
  end
end
