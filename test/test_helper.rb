# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "shoelace/rails"

require "minitest/autorun"
require "action_controller"
require "action_view"
require "action_view/testing/resolvers"
require "active_model"

require_relative '../app/helpers/shoelace/sl_form_builder'

ActionView::TestCase.include(Rails::Dom::Testing::Assertions)
Shoelace::SlFormBuilder.field_error_proc = nil

AUTOCOMPLETE_ATTRIBUTE = ActionView::VERSION::STRING >= '6.1.0' ? 'autocomplete="off"' : ''

class User
  include ActiveModel::Model

  attr_accessor :name

  validates :name, presence: true
end
