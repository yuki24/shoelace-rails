# frozen_string_literal: true
require 'test_helper'

require_relative '../../../app/helpers/shoelace/sl_form_helper'

class FormBuilderSlColorPickerTest < ActionView::TestCase
  include Shoelace::SlFormHelper

  test "#color_field" do
    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.color_field(:name)
        <sl-color-picker name="user[name]" id="user_name" label="Name"></sl-color-picker>
      HTML
    end
  end

  test "#color_field with an invalid value" do
    yuki = User.new.tap(&:validate)

    sl_form_for(yuki, url: "/") do |form|
      assert_dom_equal <<~HTML, form.color_field(:name)
        <sl-color-picker name="user[name]" id="user_name" label="Name" data-invalid="" invalid=""></sl-color-picker>
      HTML
    end
  end
end
