source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.4'

gem 'pg', '~> 0.21.0'

# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
# gem 'sass-rails', '~> 5.0'
gem 'sassc'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
#for images
gem 'aws-sdk', '~> 2.3'
gem 'figaro', '~> 1.1', '>= 1.1.1'
gem 'devise'
gem 'activeadmin'
gem 'active_skin'
gem "active_admin_import" , '3.0.0'
gem 'bootstrap-sass'
gem 'cancancan', '~> 2.3'
gem 'jquery-validation-rails', '~> 1.16'
#gem for facebook
gem 'omniauth-facebook', '~> 4.0'

#gem for google login
gem 'omniauth-google-oauth2', '~> 0.5.3'

# for image,file
gem "paperclip", "~> 5.2.1"
#gem for background scheduler
gem 'rufus-scheduler', '~> 3.4', '>= 3.4.2'

# gem for background jobs
gem 'sidekiq', '~> 5.1', '>= 5.1.1'

# gem for find user location
#gem 'geocoder', '~> 1.4', '>= 1.4.6' Freegeoip api deprecated so gem version updated
gem 'geocoder', '~> 1.4', '>= 1.4.9'
# gem for editor
gem 'ckeditor'

#for fuzzy search
gem 'textacular', '~> 5.0', '>= 5.0.1'  

#for ButterCms
gem 'buttercms-rails'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'zip-codes'
gem "chartkick"
gem "highcharts-rails"
gem 'whenever', require: false
gem 'maskmoney-rails'
gem 'jquery-datatables'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false
gem 'bootstrap'
gem 'jquery-rails'
gem "roo", "~> 2.8.0"
gem "search_api", git: "https://github.com/PureLoan/APIRead.git"
# ruby "2.4.0"