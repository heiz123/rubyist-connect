ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'faker'

Dir[Rails.root.join('spec/support/**/*.rb')].each {|f| require f }

ActiveRecord::Migration.maintain_test_schema!

Faker::Config.locale = :en

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.include LoginMacros, type: :feature

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.include FactoryGirl::Syntax::Methods

  # open_on_error: trueのFeature specが落ちたらsave_and_open_pageをコールする
  # http://stackoverflow.com/a/16935806/1058763
  config.after do |example|
    if example.metadata[:type] == :feature and example.exception.present? and example.metadata[:open_on_error] == true
      save_and_open_page
    end
  end
end
