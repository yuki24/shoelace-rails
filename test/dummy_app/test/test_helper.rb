ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"
require "action_dispatch/system_testing/server"

class ActiveSupport::TestCase
  parallelize workers: :number_of_processors
end

ActionDispatch::SystemTesting::Server.silence_puma = true

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
end
