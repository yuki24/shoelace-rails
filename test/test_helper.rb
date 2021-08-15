# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "shoelace/rails"

require "minitest/autorun"
require "action_controller"
require "action_view"
require "action_view/testing/resolvers"
require "active_model"

ActionView::TestCase.include(Rails::Dom::Testing::Assertions)

class User
  include ActiveModel::Model

  attr_accessor :name
end
