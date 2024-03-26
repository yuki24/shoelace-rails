# frozen_string_literal: true

require_relative './error_wrappable'

module Shoelace
  module Components
    class SlSwitch < ActionView::Helpers::Tags::NumberField #:nodoc:
      include ErrorWrappable

      def field_type; nil; end

      def render(&block)
        options = @options.stringify_keys
        options["value"] = options.fetch("value") { value_before_type_cast }
        add_default_name_and_id(options)
        label = options.delete('label').presence
        options["invalid"] = options["data-invalid"] = "" if object_has_errors?

        content_tag('sl-switch', label, options, &block)
      end
    end
  end
end
