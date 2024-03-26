# frozen_string_literal: true

require_relative './components/sl_checkbox'
require_relative './components/sl_color_picker'
require_relative './components/sl_input'
require_relative './components/sl_radio_group'
require_relative './components/sl_range'
require_relative './components/sl_select'
require_relative './components/sl_switch'
require_relative './components/sl_textarea'

module Shoelace
  class SlFormBuilder < ActionView::Helpers::FormBuilder #:nodoc:
    # Same concept as the Rails field_error_proc, but for Shoelace components. Set to `nil` to avoid messing up the
    # Shoelace components by default.
    cattr_accessor :field_error_proc

    {
      email: :email,
      number: :number,
      password: :password,
      search: :search,
      telephone: :tel,
      phone: :tel,
      text: :text,
      url: :url
    }.each do |field_type, field_class|
      # def email_field(method, **options, &block)
      #   Components::SlInput.new(:email, object_name, method, @template, options.with_defaults(label: label_text(method))).render(&block)
      # end
      eval <<-RUBY, nil, __FILE__, __LINE__ + 1
        def #{field_type}_field(method, **options, &block)
          Components::SlInput.new(:#{field_class}, object_name, method, @template, options.with_defaults(object: @object, label: label_text(method))).render(&block)
        end
      RUBY
    end

    def color_field(method, **options)
      Components::SlColorPicker.new(object_name, method, @template, options.with_defaults(object: @object, label: label_text(method))).render
    end
    alias color_picker color_field

    def range_field(method, **options)
      Components::SlRange.new(object_name, method, @template, options.with_defaults(object: @object, label: label_text(method))).render
    end
    alias range range_field

    def switch_field(method, **options, &block)
      if block_given?
        Components::SlSwitch.new(object_name, method, @template, options.with_defaults(object: @object)).render(&block)
      else
        Components::SlSwitch.new(object_name, method, @template, options.with_defaults(object: @object, label: label_text(method))).render(&block)
      end
    end
    alias switch switch_field

    def text_area(method, **options, &block)
      Components::SlTextarea.new(object_name, method, @template, options.with_defaults(object: @object, label: label_text(method), resize: 'auto')).render(&block)
    end

    def check_box(method, options = {}, checked_value = "1", unchecked_value = "0", &block)
      Components::SlCheckBox.new(object_name, method, @template, checked_value, unchecked_value, options.with_defaults(label: label_text(method)).merge(object: @object)).render(&block)
    end

    def select(method, choices = nil, options = {}, html_options = {}, &block)
      Components::SlSelect.new(object_name, method, @template, choices, options.with_defaults(object: @object), html_options.with_defaults(label: label_text(method)), &block).render
    end

    def collection_select(method, collection, value_method, text_method, options = {}, html_options = {}, &block)
      Components::SlCollectionSelect.new(object_name, method, @template, collection, value_method, text_method, options.with_defaults(object: @object), html_options.with_defaults(label: label_text(method)), &block).render
    end

    def grouped_collection_select(method, collection, group_method, group_label_method, option_key_method, option_value_method, options = {}, html_options = {})
      Components::SlGroupedCollectionSelect.new(object_name, method, @template, collection, group_method, group_label_method, option_key_method, option_value_method, options.with_defaults(object: @object), html_options.with_defaults(label: label_text(method))).render
    end

    def collection_radio_buttons(method, collection, value_method, text_method, options = {}, html_options = {}, &block)
      Components::SlCollectionRadioButtons.new(object_name, method, @template, collection, value_method, text_method, options.with_defaults(object: @object, label: label_text(method)), html_options).render(&block)
    end

    def submit(value = nil, options = {})
      value, options = nil, value if value.is_a?(Hash)

      @template.sl_submit_tag(value || submit_default_value, **options)
    end

    private

    def label_text(method, tag_value = nil)
      ::ActionView::Helpers::Tags::Label::LabelBuilder.new(@template, object_name.to_s, method.to_s, object, tag_value).translation
    end
  end

  FormBuilder = SlFormBuilder
  deprecate_constant :FormBuilder
end
