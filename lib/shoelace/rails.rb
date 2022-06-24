# frozen_string_literal: true

require_relative "rails/version"

if defined?(::Rails::Railtie)
  require_relative "engine"
  require_relative "railtie"
end

module Shoelace
  module Rails
    class Error < StandardError; end
  end
end
