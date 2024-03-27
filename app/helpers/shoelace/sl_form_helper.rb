# frozen_string_literal: true

require_relative './sl_form_builder'

module Shoelace
  module SlFormHelper
    ShoelaceFormBuilder = SlFormBuilder
    deprecate_constant :ShoelaceFormBuilder

    DEFAULT_FORM_PARAMETERS = { builder: SlFormBuilder }
    DIVIDER_TAG = "<sl-divider></sl-divider>".html_safe

    private_constant :DEFAULT_FORM_PARAMETERS, :DIVIDER_TAG

    def sl_form_for(*args, **options, &block)
      form_for(*args, **DEFAULT_FORM_PARAMETERS, **options, &block)
    end

    def sl_form_with(**args, &block)
      form_with(**args, **DEFAULT_FORM_PARAMETERS, &block)
    end

    # Creates a submit button with the text value as the caption, with the +submit+ attribute.
    def sl_submit_tag(value = 'Save changes', **options)
      options = options.deep_stringify_keys
      tag_options = { "type" => "submit", "variant" => "primary" }.update(options)
      set_default_disable_with(value, tag_options)

      content_tag('sl-button', value, tag_options)
    end

    # Creates a shoelace text field; use these text fields to input smaller chunks of text like a username or a search
    # query.
    #
    # For the properties available on this tag, please refer to the official documentation:
    #   https://shoelace.style/components/input?id=properties
    #
    def sl_text_field_tag(name, value = nil, **options, &block)
      content_tag('sl-input', '', { "type" => "text", "name" => name, "id" => sanitize_to_id(name), "value" => value }.update(options.stringify_keys), &block)
    end

    # Returns a string of +<sl-option>+ tags, like +options_for_select+, but prepends a +<small>+ tag to
    # each group.
    def grouped_sl_options_for_select(grouped_options, options)
      body = "".html_safe

      grouped_options.each_with_index do |container, index|
        label, values = container

        body.safe_concat(DIVIDER_TAG) if index > 0
        body.safe_concat(content_tag("small", label)) if label.present?
        body.safe_concat(sl_options_for_select(values, options))
      end

      body
    end

    # Accepts an enumerable (hash, array, enumerable, your type) and returns a string of +sl-option+ tags. Given
    # an enumerable where the elements respond to +first+ and +last+ (such as a two-element array), the “lasts” serve
    # as option values and the “firsts” as option text.
    def sl_options_for_select(enumerable, options = nil)
      return enumerable if String === enumerable

      selected, disabled = extract_selected_and_disabled(options).map { |r| Array(r).map(&:to_s) }

      enumerable.map do |element|
        html_attributes = option_html_attributes(element)
        text, value = option_text_and_value(element).map(&:to_s)

        html_attributes[:checked] ||= selected.include?(value)
        html_attributes[:disabled] ||= disabled.include?(value)
        html_attributes[:value] = value

        tag_builder.content_tag_string('sl-option', text, html_attributes)
      end.join("\n").html_safe
    end

    def sl_option_groups_from_collection_for_select(collection, group_method, group_label_method, option_key_method, option_value_method, selected_key = nil)
      body = "".html_safe

      collection.each_with_index do |group, index|
        option_tags = sl_options_from_collection_for_select(value_for_collection(group, group_method), option_key_method, option_value_method, selected_key)

        body.safe_concat(DIVIDER_TAG) if index > 0
        body.safe_concat(content_tag("small", value_for_collection(group, group_label_method)))
        body.safe_concat(option_tags)
      end

      body
    end

    # Returns a string of +<sl-option>+ tags compiled by iterating over the collection and assigning the result of
    # a call to the +value_method+ as the option value and the +text_method+ as the option text.
    def sl_options_from_collection_for_select(collection, value_method, text_method, selected = nil)
      options = collection.map do |element|
        [value_for_collection(element, text_method), value_for_collection(element, value_method), option_html_attributes(element)]
      end

      selected, disabled = extract_selected_and_disabled(selected)

      select_deselect = {
        selected: extract_values_from_collection(collection, value_method, selected),
        disabled: extract_values_from_collection(collection, value_method, disabled)
      }

      sl_options_for_select(options, select_deselect)
    end

    # Returns a +<sl-radio>+ tag for accessing a specified attribute (identified by method) on an object assigned to
    # the template (identified by object). If the current value of method is +tag_value+ the radio button will be
    # checked.
    #
    # To force the radio button to be checked pass checked: true in the options hash. You may pass HTML options there
    # as well.
    def sl_radio_button(object_name, method, tag_value, options = {}, &block)
      Components::SlRadioButton.new(object_name, method, self, tag_value, options).render(&block)
    end

    {
      email: :email,
      number: :number,
      password: :password,
      search: :search,
      telephone: :tel,
      phone: :tel,
      url: :url
    }.each do |field_type, field_class|
      # def sl_email_field_tag(method, **options, &block)
      #   sl_text_field_tag(name, value, options.merge(type: :email))
      # end
      eval <<-RUBY, nil, __FILE__, __LINE__ + 1
        # Creates a text field of type “#{field_type}”.
        def sl_#{field_type}_field_tag(method, **options, &block)
          sl_text_field_tag(name, value, options.merge(type: :#{field_class}))
        end
      RUBY
    end
  end
end
