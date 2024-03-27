# frozen_string_literal: true

require_relative './sl_form_builder'

module Shoelace
  FormBuilder = SlFormBuilder
  deprecate_constant :FormBuilder
end
