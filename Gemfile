ruby '2.1.3'
source 'https://rubygems.org'

gem 'rails', '4.1.8'

# Use postgresql as the database for Active Record
gem 'pg', '~> 0.17.1'

# Slugs
gem 'friendly_id', '~> 5.0.4'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.0'
gem 'bourbon', '~> 4.0.2'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 2.6.0'

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

gem 'slim-rails', '~> 3.0.0'

gem 'devise'
gem 'activeadmin', github: 'gregbell/active_admin'

group :development, :test do
  gem 'pry'
  gem 'pry-remote'
end

group :development, :production do
  gem 'puma', '~> 2.10.2'
  gem 'foreman', '~> 0.75.0'
end

group :development do
  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/jonleighton/spring
  gem 'spring'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'rspec-rails', '~> 3.1.0'
  gem 'capybara', '~> 2.4.4'
  gem 'poltergeist', '~> 1.5.1'
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'selenium-webdriver', '~> 2.44.0'
  gem 'database_cleaner', '~> 1.3.0'
  # required for Travis CI per http://docs.travis-ci.com/user/languages/ruby/
  gem 'rake'
end

group :production do
  # So apparently Heroku doesn't gzip stuff by default anymore
  # https://devcenter.heroku.com/articles/http-routing#gzipped-responses
  gem 'heroku-deflater'
  gem 'newrelic_rpm'
end
