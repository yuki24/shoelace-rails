# frozen_string_literal: true

require_relative './error_wrappable'

module Shoelace
  module Components
    class SlSelect < ActionView::Helpers::Tags::Select #:nodoc:
      include ErrorWrappable

      def grouped_options_for_select(grouped_options, options)
        @template_object.grouped_sl_options_for_select(grouped_options, options)
      end

      def options_for_select(container, options = nil)
        @template_object.sl_options_for_select(container, options)
      end

      def select_content_tag(option_tags, _options, html_options)
        html_options = html_options.stringify_keys
        html_options['value'] ||= value
        html_options["invalid"] = html_options["data-invalid"] = "" if object_has_errors?
        add_default_name_and_id(html_options)

        content_tag("sl-select", option_tags, html_options)
      end
    end

    class SlCollectionSelect < ActionView::Helpers::Tags::CollectionSelect #:nodoc:
      include ErrorWrappable

      def options_from_collection_for_select(collection, value_method, text_method, selected = nil)
        @template_object.sl_options_from_collection_for_select(collection, value_method, text_method, selected)
      end

      def select_content_tag(option_tags, _options, html_options)
        html_options = html_options.stringify_keys
        html_options['value'] ||= value
        html_options["invalid"] = html_options["data-invalid"] = "" if object_has_errors?
        add_default_name_and_id(html_options)

        content_tag("sl-select", option_tags, html_options)
      end
    end

    class SlGroupedCollectionSelect < ActionView::Helpers::Tags::GroupedCollectionSelect #:nodoc:
      include ErrorWrappable

      def option_groups_from_collection_for_select(collection, group_method, group_label_method, option_key_method, option_value_method, selected_key = nil)
        @template_object.sl_option_groups_from_collection_for_select(collection, group_method, group_label_method, option_key_method, option_value_method, selected_key)
      end

      def select_content_tag(option_tags, _options, html_options)
        html_options = html_options.stringify_keys
        html_options['value'] ||= value
        html_options["invalid"] = html_options["data-invalid"] = "" if object_has_errors?
        add_default_name_and_id(html_options)

        content_tag("sl-select", option_tags, html_options)
      end
    end
  end
end
