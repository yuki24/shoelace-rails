# frozen_string_literal: true
require 'test_helper'

require_relative '../../app/helpers/shoelace/sl_form_builder'

class SlFormHelperTest < ActionView::TestCase
  include Shoelace::SlFormHelper

  test "#sl_text_field_tag with name and value" do
    assert_dom_equal <<~HTML, sl_text_field_tag('name', 'Your name')
      <sl-input type="text" name="name" id="name" value="Your name"></sl-input>
    HTML
  end

  test "#sl_text_field_tag with class string" do
    assert_dom_equal <<~HTML, sl_text_field_tag('name', 'Your name', class: "admin")
      <sl-input type="text" name="name" id="name" value="Your name" class="admin"></sl-input>
    HTML
  end

  test "#sl_text_field_tag with params" do
    assert_raises ActionController::UnfilteredParameters do
      sl_text_field_tag('name', 'Your name', **ActionController::Parameters.new(key: "value"))
    end
  end

  test "#sl_text_field_tag with disabled: true" do
    assert_dom_equal <<~HTML, sl_text_field_tag('name', 'Your name', disabled: true)
      <sl-input type="text" name="name" id="name" value="Your name" disabled="disabled"></sl-input>
    HTML
  end

  test "#sl_submit_tag" do
    assert_dom_equal <<~HTML, sl_submit_tag("Save")
      <sl-button type="submit" variant="primary" data-disable-with="Save">Save</sl-button>
    HTML
  end

  test "#sl_submit_tag with onclick" do
    assert_dom_equal <<~HTML, sl_submit_tag("Save", onclick: "alert('hello!')", data: { disable_with: "Saving..." })
      <sl-button type="submit" variant="primary" onclick="alert(&#39;hello!&#39;)" data-disable-with="Saving...">Save</sl-button>
    HTML
  end

  test "#sl_radio_button" do
    assert_dom_equal(<<~HTML, sl_radio_button(:user, :name, 'userid-314', checked: true) { "Yuki Nishijima" })
      <sl-radio value="userid-314" checked="checked" id="user_name_userid-314">Yuki Nishijima</sl-radio>
    HTML
  end

  test "#sl_form_with" do
    assert_dom_equal(<<~HTML, sl_form_with(url: "/") {})
      <form action="/" accept-charset="UTF-8" data-remote="true" method="post">
        <input name="utf8" type="hidden" value="&#x2713;" #{AUTOCOMPLETE_ATTRIBUTE} />
      </sl-form>
    HTML
  end

  test "#sl_form_for" do
    assert_dom_equal(<<~HTML, sl_form_for(User.new, url: "/") { })
      <form class="new_user" id="new_user" action="/" accept-charset="UTF-8" method="post">
        <input name="utf8" type="hidden" value="&#x2713;" #{AUTOCOMPLETE_ATTRIBUTE} />
      </sl-form>
    HTML
  end
end
