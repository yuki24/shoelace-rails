# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "shoelace/rails"

require "minitest/autorun"
require "action_controller"
require "action_view"
require "action_view/testing/resolvers"

ActionView::TestCase.include(Rails::Dom::Testing::Assertions)
