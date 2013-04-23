# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    vk_id 1
    token "MyString"
    wall_post_enabled false
    name "MyString"
  end
end
