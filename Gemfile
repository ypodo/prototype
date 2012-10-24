source 'http://rubygems.org'

gem 'rails', '3.1.0'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'sqlite3', "~> 1.3.6"
gem 'less-rails-bootstrap'
gem 'haml-rails'
gem 'jquery-rails'
gem 'rspec-rails'
gem 'simplecov'
gem 'yaml_db'  

#rake db:data:dump  ->   Dump contents of Rails database to db/data.yml
#rake db:data:load   ->   Load contents of db/data.yml into the database
# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
  gem 'therubyracer'
  gem 'twitter-bootstrap-rails', :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git'
  
end
group :tests ,:development do
 
  gem 'cucumber-rails'
  gem 'cucumber-rails-training-wheels'
  gem 'database_cleaner'
  gem 'capybara'
  gem 'launchy'

end
# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end
