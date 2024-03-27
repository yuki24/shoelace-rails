# frozen_string_literal: true

require_relative './error_wrappable'

module Shoelace
  module Components
    class SlCheckbox < ActionView::Helpers::Tags::CheckBox #:nodoc:
      include ErrorWrappable

      def render(&block)
        options = @options.stringify_keys
        options["value"]   = @checked_value
        options["checked"] = true if input_checked?(options)
        options["invalid"] = options["data-invalid"] = "" if object_has_errors?
        label = options.delete("label")

        if options["multiple"]
          add_default_name_and_id_for_value(@checked_value, options)
          options.delete("multiple")
        else
          add_default_name_and_id(options)
        end

        include_hidden = options.delete("include_hidden") { true }

        sl_checkbox_tag = if block_given?
                            content_tag('sl-checkbox', '', options, &block)
                          else
                            content_tag('sl-checkbox', label, options)
                          end

        if include_hidden
          hidden_field_for_checkbox(options) + sl_checkbox_tag
        else
          sl_checkbox_tag
        end
      end
    end
  end
end
