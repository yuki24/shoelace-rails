# frozen_string_literal: true
require 'test_helper'

require_relative '../../../app/helpers/shoelace/sl_form_helper'

class FormBuilderSlCheckboxTest < ActionView::TestCase
  include Shoelace::SlFormHelper

  test "#check_box" do
    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.check_box(:name)
        <input name="user[name]" type="hidden" value="0" #{AUTOCOMPLETE_ATTRIBUTE} />
        <sl-checkbox value="1" name="user[name]" id="user_name">Name</sl-checkbox>
      HTML
    end
  end

  test "#check_box with an invalid value" do
    yuki = User.new.tap(&:validate)

    sl_form_for(yuki, url: "/") do |form|
      assert_dom_equal <<~HTML, form.check_box(:name)
        <input name="user[name]" type="hidden" value="0" #{AUTOCOMPLETE_ATTRIBUTE} />
        <sl-checkbox value="1" name="user[name]" id="user_name" data-invalid="" invalid="">Name</sl-checkbox>
      HTML
    end
  end

  test "#check_box with a block" do
    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.check_box(:name) { "Maintainer Name" }
        <input name="user[name]" type="hidden" value="0" #{AUTOCOMPLETE_ATTRIBUTE} />
        <sl-checkbox value="1" name="user[name]" id="user_name">Maintainer Name</sl-checkbox>
      HTML
    end
  end

  test "#check_box without a hidden input" do
    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.check_box(:name, include_hidden: false) { "Maintainer Name" }
        <sl-checkbox value="1" name="user[name]" id="user_name">Maintainer Name</sl-checkbox>
      HTML
    end
  end
end
