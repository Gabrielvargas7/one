# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  #config.mock_with :mocha
  #  config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  #config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.before(:all) {}

  # run this one only when you want to clean the test db
  config.after(:all){ }


  #config.mock_with :rspec
  #config.use_transactional_fixtures = true
  config.include(MailerMacros)
  config.before(:each) { reset_email }


  # these test only run when it is explicit.-because it insert image to the CDN and is very slow
  # example
  # bundle exec rspec --tag tag_image spec/models/theme_spec.rb
  config.filter_run_excluding tag_image_theme: true
  config.filter_run_excluding tag_image_user: true
  config.filter_run_excluding tag_image_bundle: true
  config.filter_run_excluding tag_image_items_design: true
  config.filter_run_excluding tag_image_bookmark: true
  config.filter_run_excluding tag_image_notification: true
  config.filter_run_excluding tag_image_user_gallery: true


end

