if ENV['CODECLIMATE_REPO_TOKEN']
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

#require 'open-uri'

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'
require 'capybara/poltergeist'

#Capybara.javascript_driver = :poltergeist
#Capybara.default_driver = :selenium
Capybara.use_default_driver

###############
#Start Test facebook login
###############

OmniAuth.config.test_mode = true
OmniAuth.config.full_host = 'http://example.com'
#OmniAuth.config.full_host = 'http://localhost:3000'

omni_hash = {
    'uid' => "12345",
    'provider' => "facebook",
    "info" => {
        "email" => Faker::Internet.email,
        "image" => 'http://graph.facebook.com/1234567/picture?type=square'
    },
    "extra" => {
        "raw_info" => {
            "first_name" => Faker::Name.first_name,
            "last_name" => Faker::Name.last_name,
            "name" => Faker::Internet.user_name,
            "gender" => "male",
            "locale" => "en",
            "email" => Faker::Internet.email
        }
    },
    "credentials" => {
        "token" => 'ABCDEF...', # OAuth 2.0 access_token, which you may wish to store
        "expires_at" => 1321747205, # when the access token expires (it always will)
        "expires" => true # this will always be true
    },
}
OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(omni_hash)


###############
# End Test facebook login
###############

def wait_for_ajax
  Timeout.timeout(Capybara.default_wait_time) do
    active = page.evaluate_script('jQuery.active')

    until active == 0
      active = page.evaluate_script('jQuery.active')
    end
  end
end


#def wait_for_dom(timeout = Capybara.default_wait_time)
#
#  uuid = SecureRandom.uuid
#  page.find("body")
#  page.evaluate_script <<-EOS
#    _.defer(function() {
#      $('body').append("<div id='#{uuid}'></div>");
#    });
#  EOS
#  page.find("##{uuid}")
#end


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

  config.include Capybara::DSL


  # these test only run when it is explicit.-because it insert image to the CDN and is very slow
  # example
  # bundle exec rspec --tag tag_image spec/models/theme_spec.rb
  config.filter_run_excluding tag_image_theme: true
  config.filter_run_excluding tag_image_user: true
  config.filter_run_excluding tag_image_bundle: true
  config.filter_run_excluding tag_image_items_design: true
  config.filter_run_excluding tag_image_bookmark: true
  config.filter_run_excluding tag_image_notification: true
  config.filter_run_excluding tag_image_user_photos: true
  config.filter_run_excluding tag_image_item: true
  config.filter_run_excluding tag_image_gray_item: true
  config.filter_run_excluding tag_image_first_time_click_item: true


  # Database Cleaner
  # config.before(:suite) do
  #   DatabaseCleaner.strategy = :transaction
  #   DatabaseCleaner.clean_with(:truncation)
  # end

  # config.after(:each) do
  #   DatabaseCleaner.start
  # end

  # config.after(:each) do
  #   DatabaseCleaner.clean
  # end



end

