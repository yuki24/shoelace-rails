# frozen_string_literal: true

require_relative './error_wrappable'

module Shoelace
  module Components
    class SlInput < ActionView::Helpers::Tags::TextField #:nodoc:
      include ErrorWrappable

      attr_reader :field_type

      def initialize(field_type, *args)
        super(*args)
        @field_type = field_type
      end

      def render(&block)
        options = @options.stringify_keys

        value = options.fetch("value") { value_before_type_cast }
        options["value"] = value if value.present?

        options["size"] = options["maxlength"] unless options.key?("size")
        options["type"] ||= field_type
        options["invalid"] = options["data-invalid"] = "" if object_has_errors?

        add_default_name_and_id(options)

        content_tag('sl-input', '', options, &block)
      end
    end
  end
end
