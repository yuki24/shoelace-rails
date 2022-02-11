# frozen_string_literal: true

module Shoelace
  class Engine < ::Rails::Engine #:nodoc:
    config.shoelace = ActiveSupport::OrderedOptions.new
    config.shoelace.use_sl_form_tag = false
  end
end
