ruby '2.1.3'
source 'https://rubygems.org'

gem 'rails', '4.2.0'

# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18.1'

# Slugs
gem 'friendly_id', '~> 5.1.0'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.1'
gem 'bourbon', '~> 4.2.1'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 2.7.1'

# Use CoffeeScript for .js.coffee assets and views
#gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
#gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more:
# https://github.com/rails/turbolinks
#gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
#gem 'jbuilder', '~> 2.0'

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

gem 'slim-rails', '~> 3.0.1'

gem 'devise'
gem 'activeadmin', github: 'gregbell/active_admin'

group :development, :test do
  gem 'pry'
  gem 'pry-remote'
end

group :development, :production do
  gem 'puma', '~> 2.11.1'
end

group :development do
  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/jonleighton/spring
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'web-console', '~> 2.0'
end

group :test do
  gem 'rspec-rails', '~> 3.2.1'
  gem 'capybara', '~> 2.4.4'
  gem 'poltergeist', '~> 1.6.0'
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'selenium-webdriver', '~> 2.45.0'
  gem 'database_cleaner', '~> 1.4.1'
  # required for Travis CI per http://docs.travis-ci.com/user/languages/ruby/
  gem 'rake'
end

group :production do
  # So apparently Heroku doesn't gzip stuff by default anymore
  # https://devcenter.heroku.com/articles/http-routing#gzipped-responses
  gem 'heroku-deflater'
  gem 'newrelic_rpm'
end
