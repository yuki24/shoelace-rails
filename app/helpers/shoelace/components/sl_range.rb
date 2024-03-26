# frozen_string_literal: true

require_relative './error_wrappable'

module Shoelace
  module Components
    class SlRange < ActionView::Helpers::Tags::NumberField #:nodoc:
      include ErrorWrappable

      def field_type; nil; end

      def render
        @options["invalid"] = @options["data-invalid"] = "" if object_has_errors?
        super
      end

      def tag(tag_name, *args, &block)
        tag_name.to_s == 'input' ? content_tag('sl-range', '', *args, &block) : super
      end
    end
  end
end
