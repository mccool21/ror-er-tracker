ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require_relative "test_helpers/session_test_helper"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # "ashes_of_war" doesn't classify back to AshOfWar, so fixtures can't infer the model on their own.
    set_fixture_class "ashes_of_war" => AshOfWar

    # Add more helper methods to be used by all tests here...
  end
end
