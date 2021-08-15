require 'test_helper'

require_relative '../../app/helpers/shoelace/form_helper'

class FormHelperTest < ActionView::TestCase
  include Shoelace::FormHelper

  test "#sl_text_field_tag with name and value" do
    assert_dom_equal '<sl-input type="text" name="name" id="name" value="Your name"></sl-input>', sl_text_field_tag('name', 'Your name')
  end

  test "#sl_text_field_tag with class string" do
    assert_dom_equal '<sl-input type="text" name="name" id="name" value="Your name" class="admin"></sl-input>', sl_text_field_tag('name', 'Your name', class: "admin")
  end

  test "#sl_text_field_tag with params" do
    assert_raises ActionController::UnfilteredParameters do
      sl_text_field_tag('name', 'Your name', **ActionController::Parameters.new(key: "value"))
    end
  end

  test "#sl_text_field_tag with disabled: true" do
    assert_dom_equal '<sl-input type="text" name="name" id="name" value="Your name" disabled="disabled"></sl-input>', sl_text_field_tag('name', 'Your name', disabled: true)
  end
end
