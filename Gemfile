source 'https://rubygems.org'
ruby '3.2.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.0.0'
# Use PostGres as the database for production
gem 'pg', '~> 1.5'
# Use Puma as the app server
gem 'puma', '~> 6.0'
# Use Terser as compressor for JavaScript assets (Rails 7 default; replaces uglifier)
gem 'terser', '~> 1.2'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster
gem 'turbolinks', '~> 5.0'
# Build JSON APIs with ease
gem 'jbuilder', '~> 2.11'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1'
# Paginate
gem 'will_paginate', '~> 4.0'
gem 'bootstrap-will_paginate', '~> 1.0'
# Bootstrap
gem 'bootstrap-sass', '~> 3.4'
gem 'sassc-rails'
gem 'font-awesome-sass'
# Image support
gem 'carrierwave', '~> 3.0'
gem 'mini_magick', '~> 4.12'
gem 'fog-aws'
# Object geocoding
gem 'geocoder'
# Google Maps (gmaps4rails ships .coffee files, requires coffee-rails)
gem 'gmaps4rails'
gem 'coffee-rails', '~> 5.0'
# Sprockets for asset pipeline (required explicitly in Rails 7)
gem 'sprockets-rails'
# Bootsnap for faster boot times
gem 'bootsnap', require: false
# Pin minitest to 5.x (Rails 7.0 is incompatible with minitest 6)
gem 'minitest', '~> 5.20'
# Ruby 3.1+ removed these from stdlib
gem 'net-smtp', require: false
gem 'net-imap', require: false
gem 'net-pop', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3', '~> 1.6'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 4.2'
end

group :test do
  gem 'rails-controller-testing', '~> 1.0'
  gem 'minitest-reporters',       '~> 1.6'
  gem 'guard',                    '~> 2.18'
  gem 'guard-minitest',           '~> 2.4'
  gem 'simplecov',                '~> 0.22', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
