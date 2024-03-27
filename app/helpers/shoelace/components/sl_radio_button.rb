# frozen_string_literal: true

require_relative './error_wrappable'

module Shoelace
  module Components
    class SlRadioButton < ActionView::Helpers::Tags::RadioButton #:nodoc:
      include ErrorWrappable

      def render(&block)
        options = @options.stringify_keys
        options["value"]   = @tag_value
        add_default_name_and_id_for_value(@tag_value, options)
        options.delete("name")

        @template_object.content_tag('sl-radio', '', options.except("type"), &block)
      end
    end
  end
end
