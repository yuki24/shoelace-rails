# frozen_string_literal: true
require 'test_helper'

require_relative '../../../app/helpers/shoelace/sl_form_helper'

class FormBuilderSlRangeTest < ActionView::TestCase
  include Shoelace::SlFormHelper

  test "#range_field" do
    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.range_field(:name)
        <sl-range label="Name" name="user[name]" id="user_name"></sl-range>
      HTML
    end
  end

  test "#range_field with an invalid value" do
    yuki = User.new.tap(&:validate)

    sl_form_for(yuki, url: "/") do |form|
      assert_dom_equal <<~HTML, form.range_field(:name)
        <sl-range label="Name" name="user[name]" id="user_name" data-invalid="" invalid=""></sl-range>
      HTML
    end
  end

  test "#range_field without a label" do
    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.range_field(:name, label: nil)
        <sl-range name="user[name]" id="user_name"></sl-range>
      HTML
    end
  end
end
