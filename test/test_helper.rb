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

class User
  include ActiveModel::Model

  attr_accessor :name

  validates :name, presence: true
end

class ActionView::TestCase
  AUTOCOMPLETE_ATTRIBUTE = ActionView::VERSION::STRING >= '6.1.0' ? 'autocomplete="off"' : ''

  def with_default_input_slot_method(input_slot_method = :render_default_slot)
    Shoelace::SlFormBuilder.default_input_slot_method = input_slot_method
    yield
  ensure
    Shoelace::SlFormBuilder.default_input_slot_method = nil
  end

  private

  def render_default_slot(resource, _attribute)
    content_tag(:div, "Help text for #{_attribute} #{resource.name}", slot: "help-text")
  end
end
