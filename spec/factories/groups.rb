# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :group do
    active false
    user_id 1
    name "MyString"
    screen_name "MyString"
    photo_urls ""
  end
end
