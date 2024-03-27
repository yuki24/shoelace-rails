# frozen_string_literal: true

require_relative './error_wrappable'

module Shoelace
  module Components
    module SlSelectRenderable
      def select_content_tag(option_tags, _options, html_options)
        html_options = html_options.stringify_keys
        html_options['value'] ||= value
        html_options["invalid"] = html_options["data-invalid"] = "" if object_has_errors?
        add_default_name_and_id(html_options)

        @template_object.content_tag("sl-select", html_options) do
          "".html_safe.tap do |html|
            html.safe_concat(option_tags)
            html.safe_concat(@template_object.capture(&slot)) if slot
          end
        end
      end
    end

    class SlSelect < ActionView::Helpers::Tags::Select #:nodoc:
      include ErrorWrappable
      include SlSelectRenderable

      attr_reader :slot

      def initialize(object_name, method_name, template_object, choices, options, html_options, slot)
        @slot = slot
        super(object_name, method_name, template_object, choices, options, html_options)
      end

      def grouped_options_for_select(grouped_options, options)
        @template_object.grouped_sl_options_for_select(grouped_options, options)
      end

      def options_for_select(container, options = nil)
        @template_object.sl_options_for_select(container, options)
      end
    end

    class SlCollectionSelect < ActionView::Helpers::Tags::CollectionSelect #:nodoc:
      include ErrorWrappable
      include SlSelectRenderable

      attr_reader :slot

      def initialize(object_name, method_name, template_object, collection, value_method, text_method, options, html_options, slot)
        @slot = slot
        super(object_name, method_name, template_object, collection, value_method, text_method, options, html_options)
      end

      def options_from_collection_for_select(collection, value_method, text_method, selected = nil)
        @template_object.sl_options_from_collection_for_select(collection, value_method, text_method, selected)
      end
    end

    class SlGroupedCollectionSelect < ActionView::Helpers::Tags::GroupedCollectionSelect #:nodoc:
      include ErrorWrappable
      include SlSelectRenderable

      attr_reader :slot

      def initialize(object_name, method_name, template_object, collection, group_method, group_label_method, option_key_method, option_value_method, options, html_options, slot)
        @slot = slot
        super(object_name, method_name, template_object, collection, group_method, group_label_method, option_key_method, option_value_method, options, html_options)
      end

      def option_groups_from_collection_for_select(collection, group_method, group_label_method, option_key_method, option_value_method, selected_key = nil)
        @template_object.sl_option_groups_from_collection_for_select(collection, group_method, group_label_method, option_key_method, option_value_method, selected_key)
      end
    end
  end
end
