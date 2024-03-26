# frozen_string_literal: true
require 'test_helper'

require_relative '../../../app/helpers/shoelace/sl_form_helper'

class FormBuilderSlRangeTest < ActionView::TestCase
  include Shoelace::SlFormHelper

  test "#switch_field" do
    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.switch_field(:name)
        <sl-switch name="user[name]" id="user_name">Name</sl-switch>
      HTML
    end
  end

  test "#switch_field with an invalid value" do
    yuki = User.new.tap(&:validate)

    sl_form_for(yuki, url: "/") do |form|
      assert_dom_equal <<~HTML, form.switch_field(:name)
        <sl-switch name="user[name]" id="user_name" data-invalid="" invalid="">Name</sl-switch>
      HTML
    end
  end
end
