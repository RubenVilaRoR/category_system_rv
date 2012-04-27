source 'https://rubygems.org'

gem 'rails', '3.2.3'

# Databse
# gem 'sqlite3'
# gem 'pg'
gem 'mysql2'

gem 'jquery-rails'

# authentication
gem "sorcery", git: "git://github.com/NoamB/sorcery.git"
gem 'simple_form'

# file attachment
gem "carrierwave", "~> 0.5.8"
gem "fog", "~> 1.1.2"

# searching
gem "ransack", "~> 0.6.0"

# friendly_id
gem "friendly_id", "~> 4.0.3"

# pagination
gem "kaminari", "~> 0.13.0"

# captcha
gem "recaptcha", :require => "recaptcha/rails"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.5'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'bootstrap-sass', '~> 2.0.2'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
end


# testing
group :test, :development do
  gem "capybara", "~> 1.1.2"
  gem "rspec-rails", "~> 2.9.0"
  gem 'launchy'
  gem "factory_girl_rails", "~> 3.1"
  gem 'spork-rails'
  gem 'foreman'
  gem 'database_cleaner'
end

group :development do
  gem 'pry-rails'
  gem 'pry-doc'
  
  # To use debugger
  # gem 'ruby-debug19', :require => 'ruby-debug'
end

group :production do
  gem 'thin'
  gem 'newrelic_rpm'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'