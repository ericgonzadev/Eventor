source 'https://rubygems.org'
ruby '~> 2.5.x'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.0.2'
# Use PostGres as the database
gem 'pg', '0.21.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
#Paginate
gem 'will_paginate', '3.1.0'
gem 'bootstrap-will_paginate', '0.0.10'
#Bootsrtap
gem 'bootstrap-sass', '~> 3.4.1'
gem 'sass-rails', '>= 3.2'
gem 'font-awesome-sass'
#Image support
gem 'carrierwave', '0.11.2'
gem 'mini_magick', '4.5.1'
gem 'fog', '1.38.0'
#Object geocoding
gem 'geocoder'
#Google Maps
gem 'gmaps4rails'
#Ruby I18n
gem 'i18n'
# Suite of testing facilities supporting TDD, BDD, mocking, and benchmarking
gem 'minitest', '~> 5.10', '!= 5.10.2'

group :production do
  gem 'rails_12factor'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
end

group :test do
  gem 'rails-controller-testing', '1.0.2'
  gem 'minitest-reporters',       '1.1.14'
  gem 'guard',                    '2.13.0'
  gem 'guard-minitest',           '2.4.4'
  gem 'simplecov',                '0.15.1', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
