# frozen_string_literal: true

require_relative './error_wrappable'

module Shoelace
  module Components
    class SlColorPicker < ActionView::Helpers::Tags::ColorField #:nodoc:
      RGB_VALUE_REGEX = /#[0-9a-fA-F]{6}/.freeze

      include ErrorWrappable

      def field_type; nil; end

      def tag(tag_name, *args, &block)
        tag_name.to_s == 'input' ? content_tag('sl-color-picker', '', *args, &block) : super
      end

      def render
        @options["invalid"] = @options["data-invalid"] = "" if object_has_errors?
        super
      end

      private

      def validate_color_string(string)
        string.downcase if RGB_VALUE_REGEX.match?(string)
      end
    end
  end
end
