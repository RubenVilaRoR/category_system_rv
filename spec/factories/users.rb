FactoryGirl.define do
  salt = "asdasdastr4325234324sdfds"
  factory :user do
    sequence(:username){|n| "user#{n}" }
    name 'User Name'
    active true
    sequence(:email) {|n| "email-#{n}@foo.com"}
    password 'secret'
    password_confirmation 'secret'
    salt salt
    crypted_password Sorcery::CryptoProviders::BCrypt.encrypt("secret", salt)
    association :organization
  end
  
  factory :admin, parent: :user do
    sequence(:username){|n| "admin#{n}"}
    admin true
  end
end