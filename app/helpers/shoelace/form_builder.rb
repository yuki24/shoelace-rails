# frozen_string_literal: true

require_relative './components/sl_checkbox'
require_relative './components/sl_color_picker'
require_relative './components/sl_input'
require_relative './components/sl_radio_group'
require_relative './components/sl_range'
require_relative './components/sl_select'
require_relative './components/sl_switch'
require_relative './components/sl_textarea'

module Shoelace
  FormBuilder = SlFormBuilder
  deprecate_constant :FormBuilder
end
