source 'https://rubygems.org'

gem 'rails', '4.2.3'
gem 'sqlite3'

# Organizes business logic, keeps it out of controllers and models:
gem 'outbacker'

# ERB alternative:
gem 'slim'

# ZURB CSS framework:
gem 'foundation-rails'

# Validation/normalization
gem 'phony_rails'
gem 'email_validator'

# Set server-side timezone automatically based on browser timezone:
gem 'browser-timezone-rails'

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
  gem 'minitest-rails-capybara'
  gem 'minitest-reporters'
  gem 'mocha'
  gem 'site_prism'
  gem 'tedium'

  # Run a single minitest case:
  gem 'm'
end
