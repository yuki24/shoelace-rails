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

        content_tag('sl-radio', '', options.except("type"), &block)
      end
    end

    class SlCollectionRadioButtons < ActionView::Helpers::Tags::CollectionRadioButtons #:nodoc:
      include ErrorWrappable

      class RadioButtonBuilder < Builder # :nodoc:
        def label(*)
          text
        end

        def radio_button(extra_html_options = {}, &block)
          html_options = extra_html_options.merge(@input_html_options)
          html_options[:skip_default_ids] = false
          @template_object.sl_radio_button(@object_name, @method_name, @value, html_options, &block)
        end
      end

      def render(&block)
        render_collection_for(RadioButtonBuilder, &block)
      end

      private

      def render_collection(&block)
        html_options = @html_options.stringify_keys
        html_options["value"] = value
        add_default_name_and_id(html_options)
        html_options["label"] = @options[:label].presence
        html_options["invalid"] = html_options["data-invalid"] = "" if object_has_errors?

        content_tag('sl-radio-group', html_options) { super(&block) }
      end

      def hidden_field
        ''.html_safe
      end

      def render_component(builder)
        builder.radio_button { builder.label }
      end
    end
  end
end
