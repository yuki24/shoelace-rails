# frozen_string_literal: true

require_relative "rails/version"
require_relative "engine" if defined?(::Rails::Railtie)

module Shoelace
  module Rails
    class Error < StandardError; end
  end
end
