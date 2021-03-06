source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.7'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.0'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.7'
#
gem 'jwt'

# Soft delete
gem 'paranoia', '~> 2.4', '>= 2.4.3'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false
gem 'dotenv-rails'
#Sendgrid
gem 'sendgrid-ruby'
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

# Use Rest-Client for external API integration
gem 'rest-client'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem "faker", "~> 2.18"
  gem 'rspec-rails', '~> 5.0', '>= 5.0.1'
  gem "factory_bot_rails", "~> 6.2"
  gem "rswag-specs", "~> 2.4"
end

group :development do
  gem 'rubocop', '~> 1.16'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'awesome_print', '~> 1.9', '>= 1.9.2'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem "database_cleaner-active_record", "~> 2.0"
  gem "simplecov", "~> 0.21.2", require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'active_model_serializers', '~> 0.10.12'

gem 'aws-sdk-s3', '~> 1.95', '>= 1.95.1'

gem "pager_api", "~> 0.3.2"

gem "pagy", "~> 4.8"

gem "rswag-api", "~> 2.4"

gem "rswag-ui", "~> 2.4"