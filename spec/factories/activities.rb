# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :activity do
    date "2012-03-19"
    info "The infor of the activity"
    association :category 
    association :user
    association :organization
    tags "tag1, tag2, tag3"
    priority "test"
  end
end
