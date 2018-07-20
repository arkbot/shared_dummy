ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../dummy/config/environment', __FILE__)

require 'spec_helper'

# Prevent database truncation if the environment is production
abort('Running in production mode!') if Rails.env.production?

require 'rspec/rails'

require 'shared_platform/test_support'

# Automatically require all support files for testing
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migration and applies them before tests are run.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  # config.before(:all) do
  #   Bundler.with_clean_env { `cd #{Rails.root} && RAILS_ENV=test bundle exec rake setup` }
  # end
end
