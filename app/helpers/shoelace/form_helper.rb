# frozen_string_literal: true

require_relative './sl_form_builder'

module Shoelace
  FormHelper = SlFormHelper
  deprecate_constant :FormHelper
end
