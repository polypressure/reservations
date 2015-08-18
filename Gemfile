source 'https://rubygems.org'

gem 'rails', '4.2.3'
gem 'sqlite3', '~> 1.3.10'

# Organizes business logic, keeps it out of controllers and models:
gem 'outbacker', '~> 0.1.2'

# ERB alternative:
gem 'slim', '~> 3.0.6'

# ZURB CSS framework:
gem 'foundation-rails', '~> 5.5.2.1'

# Validation/normalization
gem 'phony_rails', '~> 0.12.9'
gem 'email_validator', '~> 1.6.0'

# Set server-side timezone automatically based on browser timezone:
gem 'browser-timezone-rails', '~> 0.0.8'

gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'turbolinks'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  gem 'minitest-rails-capybara', '~> 2.1.1'
  gem 'minitest-reporters', '~> 1.0.19'
  gem 'mocha', '~> 1.1.0'
  gem 'site_prism', '~> 2.7'
  gem 'tedium', '~> 0.0.5'
  gem 'codeclimate-test-reporter', '~> 0.4'

  # Run a single minitest case:
  gem 'm', '~> 1.3.4'
end
