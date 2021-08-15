module Shoelace
  module FormHelper
    class ShoelaceInputField < ActionView::Helpers::Tags::TextField
      attr_reader :field_type

      def initialize(field_type, *args)
        super(*args)
        @field_type = field_type
      end

      def render(&block)
        options = @options.stringify_keys

        value = options.fetch("value") { value_before_type_cast }
        options["value"] = value if value.present?

        options["size"] = options["maxlength"] unless options.key?("size")
        options["type"] ||= field_type
        options["invalid"] = options.fetch("invalid") { @object&.errors&.dig(@method_name)&.presence }
        add_default_name_and_id(options)

        @template_object.content_tag('sl-input', '', options, &block)
      end
    end

    class ShoelaceColorPicker < ActionView::Helpers::Tags::ColorField
      def field_type; nil; end

      def tag(tag_name, *args, &block)
        tag_name.to_s == 'input' ? content_tag('sl-color-picker', '', *args, &block) : super
      end
    end

    class ShoelaceRange < ActionView::Helpers::Tags::NumberField
      def field_type; nil; end

      def tag(tag_name, *args, &block)
        tag_name.to_s == 'input' ? content_tag('sl-range', '', *args, &block) : super
      end
    end

    class ShoelaceSwitch < ActionView::Helpers::Tags::TextField
      def field_type; nil; end

      def render(&block)
        options = @options.stringify_keys
        options["value"] = options.fetch("value") { value_before_type_cast }
        add_default_name_and_id(options)

        @template_object.content_tag('sl-switch', @method_name.to_s.humanize, options, &block)
      end
    end

    class ShoelaceTextArea < ActionView::Helpers::Tags::TextArea
      def content_tag(tag_name, content, options)
        options[:value] = content if content.present?

        tag_name.to_s == 'textarea' ? super('sl-textarea', '', options) : super
      end
    end

    class ShoelaceFormBuilder < ActionView::Helpers::FormBuilder
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
        #   ShoelaceInputField.new(:email, object_name, method, @template, options.with_defaults(label: method.to_s.humanize)).render(&block)
        # end
        eval <<-RUBY, nil, __FILE__, __LINE__ + 1
          def #{field_type}_field(method, **options, &block)
            ShoelaceInputField.new(:#{field_class}, object_name, method, @template, options.with_defaults(label: method.to_s.humanize)).render(&block)
          end
        RUBY
      end

      def color_field(method, options = {})
        ShoelaceColorPicker.new(object_name, method, @template, options.with_defaults(value: "#ffffff")).render
      end
      alias color_picker color_field

      def range_field(method, **options)
        ShoelaceRange.new(object_name, method, @template, options).render
      end
      alias range range_field

      def switch_field(method, **options, &block)
        ShoelaceSwitch.new(object_name, method, @template, options).render(&block)
      end
      alias switch switch_field

      def text_area(method, **options)
        ShoelaceTextArea.new(object_name, method, @template, options.with_defaults(resize: 'auto')).render
      end

      def submit(value = nil, options = {})
        value, options = nil, value if value.is_a?(Hash)

        @template.sl_submit_tag(value || submit_default_value, options)
      end
    end

    DEFAULT_FORM_PARAMETERS = {
      builder: ShoelaceFormBuilder,
      data: {
        remote: true,
      }
    }

    OPENING_SL_FORM_TAG = '<sl-form'.html_safe
    CLOSING_SL_FORM_TAG = '</sl-form>'.html_safe

    private_constant :DEFAULT_FORM_PARAMETERS, :OPENING_SL_FORM_TAG, :CLOSING_SL_FORM_TAG

    def sl_form_for(*args, **options, &block)
      content = form_for(*args, **DEFAULT_FORM_PARAMETERS.deep_merge(options), &block)
      content[0, 5]  = OPENING_SL_FORM_TAG
      content[-7, 7] = CLOSING_SL_FORM_TAG
      content
    end

    def sl_form_with(**args, &block)
      content = form_with(**args, **DEFAULT_FORM_PARAMETERS.except(:data), &block)
      content[0, 5]  = OPENING_SL_FORM_TAG
      content[-7, 7] = CLOSING_SL_FORM_TAG
      content
    end

    def sl_form_tag(url_for_options = {}, options = {}, &block)
      content = form_tag(url_for_options, options.with_defaults(DEFAULT_FORM_PARAMETERS.except(:builder)), &block)
      content[0, 5]  = OPENING_SL_FORM_TAG
      content[-7, 7] = CLOSING_SL_FORM_TAG
      content
    end

    def sl_button_tag(**attrs, &block)
      content_tag("sl-button", **attrs, &block)
    end

    def sl_button_to(href, **attrs, &block)
      sl_button_tag(href: href, **attrs, &block)
    end

    def sl_submit_tag(value = 'Save changes', options = {})
      options = options.deep_stringify_keys
      tag_options = { "submit" => true, "type" => "primary" }.update(options)
      set_default_disable_with(value, tag_options)

      content_tag 'sl-button', value, tag_options
    end

    def sl_text_field_tag(name, value = nil, **options, &block)
      content_tag('sl-input', '', { "type" => "text", "name" => name, "id" => sanitize_to_id(name), "value" => value }.update(options.stringify_keys), &block)
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
        def sl_#{field_type}_field_tag(method, **options, &block)
          sl_text_field_tag(name, value, options.merge(type: :#{field_class}))
        end
      RUBY
    end
  end
end
