# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category do
    sequence(:name) {|n| "Category #{n}" }
    association :organization
    color '#000000'
    group 'Group 1'
    association :folder
  end
end
