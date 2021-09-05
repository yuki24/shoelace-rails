require_relative "boot"

require "rails"
require "active_model/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module ShoelaceTest
  class Application < Rails::Application
    config.load_defaults 6.1
    Rails.backtrace_cleaner.remove_silencers! if ENV["BACKTRACE"]
  end
end
