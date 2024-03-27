# frozen_string_literal: true

require_relative './error_wrappable'

module Shoelace
  module Components
    class SlTextarea < ActionView::Helpers::Tags::NumberField #:nodoc:
      include ErrorWrappable

      def render(&block)
        options = @options.stringify_keys
        options["value"] = options.fetch("value") { value_before_type_cast }
        options["invalid"] = options["data-invalid"] = "" if object_has_errors?
        add_default_name_and_id(options)

        @template_object.content_tag("sl-textarea", '', options, &block)
      end
    end
  end
end
