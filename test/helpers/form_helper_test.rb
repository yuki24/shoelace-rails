require 'test_helper'

require_relative '../../app/helpers/shoelace/form_helper'

class FormHelperTest < ActionView::TestCase
  include Shoelace::FormHelper

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
      <sl-button submit="true" type="primary" data-disable-with="Save">Save</sl-button>
    HTML
  end

  test "#sl_submit_tag with onclick" do
    assert_dom_equal <<~HTML, sl_submit_tag("Save", onclick: "alert('hello!')", data: { disable_with: "Saving..." })
      <sl-button submit="true" type="primary" onclick="alert(&#39;hello!&#39;)" data-disable-with="Saving...">Save</sl-button>
    HTML
  end

  test "#sl_button_tag" do
    assert_dom_equal(<<~HTML, sl_button_tag { "Submit" })
      <sl-button>Submit</sl-button>
    HTML
  end

  test "#sl_radio_button" do
    assert_dom_equal(<<~HTML, sl_radio_button(:user, :name, 'userid-314', checked: true) { "Yuki Nishijima" })
      <sl-radio value="userid-314" checked="checked" name="user[name]" id="user_name_userid-314">Yuki Nishijima</sl-radio>
    HTML
  end

  test "#sl_form_tag" do
    assert_dom_equal(<<~HTML, sl_form_tag("/posts") { })
      <sl-form data-remote="true" action="/posts" accept-charset="UTF-8" method="post">
        <input name="utf8" type="hidden" value="&#x2713;" />
      </sl-form>
    HTML
  end

  test "#sl_form_with" do
    assert_dom_equal(<<~HTML, sl_form_with(url: "/") {})
      <sl-form action="/" accept-charset="UTF-8" data-remote="true" method="post">
        <input name="utf8" type="hidden" value="&#x2713;" />
      </sl-form>
    HTML
  end

  test "#sl_form_for" do
    assert_dom_equal(<<~HTML, sl_form_for(User.new, url: "/") { })
      <sl-form class="new_user" id="new_user" data-remote="true" action="/" accept-charset="UTF-8" method="post">
        <input name="utf8" type="hidden" value="&#x2713;" />
      </sl-form>
    HTML
  end

  test "#text_field" do
    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.text_field(:name)
        <sl-input label="Name" type="text" name="user[name]" id="user_name"></sl-input>
      HTML
    end
  end

  test "#text_field with a default value" do
    sl_form_for(User.new(name: "Yuki"), url: "/") do |form|
      assert_dom_equal <<~HTML, form.text_field(:name)
        <sl-input label="Name" type="text" name="user[name]" id="user_name" value="Yuki"></sl-input>
      HTML
    end
  end

  test "#email_field" do
    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.email_field(:name)
        <sl-input label="Name" type="email" name="user[name]" id="user_name"></sl-input>
      HTML
    end
  end

  test "#number_field" do
    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.number_field(:name)
        <sl-input label="Name" type="number" name="user[name]" id="user_name"></sl-input>
      HTML
    end
  end

  test "#password_field" do
    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.password_field(:name)
        <sl-input label="Name" type="password" name="user[name]" id="user_name"></sl-input>
      HTML
    end
  end

  test "#search_field" do
    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.search_field(:name)
        <sl-input label="Name" type="search" name="user[name]" id="user_name"></sl-input>
      HTML
    end
  end

  test "#telephone_field" do
    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.telephone_field(:name)
        <sl-input label="Name" type="tel" name="user[name]" id="user_name"></sl-input>
      HTML
    end
  end

  test "#phone_field" do
    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.phone_field(:name)
        <sl-input label="Name" type="tel" name="user[name]" id="user_name"></sl-input>
      HTML
    end
  end

  test "#text_field with a block" do
    sl_form_for(User.new(name: "Yuki"), url: "/") do |form|
      assert_dom_equal <<~HTML, form.text_field(:name) { 'slot' }
        <sl-input label="Name" type="text" name="user[name]" id="user_name" value="Yuki">slot</sl-input>
      HTML
    end
  end

  test "#url_field" do
    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.url_field(:name)
        <sl-input label="Name" type="url" name="user[name]" id="user_name"></sl-input>
      HTML
    end
  end

  test "#color_field" do
    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.color_field(:name)
        <sl-color-picker value="#ffffff" name="user[name]" id="user_name"></sl-color-picker>
      HTML
    end
  end

  test "#range_field" do
    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.range_field(:name)
        <sl-range name="user[name]" id="user_name"></sl-range>
      HTML
    end
  end

  test "#switch_field" do
    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.switch_field(:name)
        <sl-switch name="user[name]" id="user_name">Name</sl-switch>
      HTML
    end
  end

  test "#text_area" do
    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.text_area(:name)
        <sl-textarea resize="auto" name="user[name]" id="user_name"></sl-textarea>
      HTML
    end
  end

  test "#check_box" do
    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.check_box(:name)
        <sl-checkbox value="1" name="user[name]" id="user_name">Name</sl-checkbox>
      HTML
    end
  end

  test "#check_box with a block" do
    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.check_box(:name) { "Maintainer Name" }
        <sl-checkbox value="1" name="user[name]" id="user_name">Maintainer Name</sl-checkbox>
      HTML
    end
  end

  test "#select" do
    users = {
      "Yuki Nishijima" => 1,
      "Matz" => 2,
      "Koichi Sasada" => 3
    }

    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.select(:name, users)
        <sl-select name="user[name]" id="user_name">
          <sl-menu-item value="1">Yuki Nishijima</sl-menu-item>
          <sl-menu-item value="2">Matz</sl-menu-item>
          <sl-menu-item value="3">Koichi Sasada</sl-menu-item>
        </sl-select>
      HTML
    end
  end

  test "#select with multiple" do
    users = {
      "Yuki Nishijima" => 1,
      "Matz" => 2,
      "Koichi Sasada" => 3
    }

    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.select(:name, users, {}, { multiple: true })
        <sl-select name="user[name][]" id="user_name" multiple="multiple">
          <sl-menu-item value="1">Yuki Nishijima</sl-menu-item>
          <sl-menu-item value="2">Matz</sl-menu-item>
          <sl-menu-item value="3">Koichi Sasada</sl-menu-item>
        </sl-select>
      HTML
    end
  end

  test "#select with grouped options" do
    users = {
      "Main maintainers" => [
        ["Matz", 2],
        ["Koichi Sasada", 3]
      ],
      "Default gem maintainers" => [
        ["Yuki Nishijima", 1],
      ]
    }

    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.select(:name, users)
        <sl-select name="user[name]" id="user_name">
          <sl-menu-label>Main maintainers</sl-menu-label>
          <sl-menu-item value="2">Matz</sl-menu-item>
          <sl-menu-item value="3">Koichi Sasada</sl-menu-item>
          <sl-menu-divider></sl-menu-divider>
          <sl-menu-label>Default gem maintainers</sl-menu-label>
          <sl-menu-item value="1">Yuki Nishijima</sl-menu-item>
        </sl-select>
      HTML
    end
  end

  test "#select with grouped options with a default value" do
    users = {
      "Main maintainers" => [
        ["Matz", 2],
        ["Koichi Sasada", 3]
      ],
      "Default gem maintainers" => [
        ["Yuki Nishijima", 1],
      ]
    }

    sl_form_for(User.new(name: "2"), url: "/") do |form|
      assert_dom_equal <<~HTML, form.select(:name, users)
        <sl-select name="user[name]" id="user_name">
          <sl-menu-label>Main maintainers</sl-menu-label>
          <sl-menu-item value="2" checked="checked">Matz</sl-menu-item>
          <sl-menu-item value="3">Koichi Sasada</sl-menu-item>
          <sl-menu-divider></sl-menu-divider>
          <sl-menu-label>Default gem maintainers</sl-menu-label>
          <sl-menu-item value="1">Yuki Nishijima</sl-menu-item>
        </sl-select>
      HTML
    end
  end

  test "#collection_select" do
    users = {
      1 => "Yuki Nishijima",
      2 => "Matz",
      3 => "Koichi Sasada",
    }

    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.collection_select(:name, users, :first, :last)
        <sl-select name="user[name]" id="user_name">
          <sl-menu-item value="1">Yuki Nishijima</sl-menu-item>
          <sl-menu-item value="2">Matz</sl-menu-item>
          <sl-menu-item value="3">Koichi Sasada</sl-menu-item>
        </sl-select>
      HTML
    end
  end

  test "#collection_radio_buttons" do
    users = {
      1 => "Yuki Nishijima",
      2 => "Matz",
      3 => "Koichi Sasada",
    }

    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.collection_radio_buttons(:name, users, :first, :last)
        <sl-radio-group no-fieldset="true">
          <sl-radio name="user[name]" value="1" id="user_name_1">Yuki Nishijima</sl-radio>
          <sl-radio name="user[name]" value="2" id="user_name_2">Matz</sl-radio>
          <sl-radio name="user[name]" value="3" id="user_name_3">Koichi Sasada</sl-radio>
        </sl-radio-group>
      HTML
    end
  end

  test "#collection_radio_buttons with a default value" do
    users = {
      1 => "Yuki Nishijima",
      2 => "Matz",
      3 => "Koichi Sasada",
    }

    sl_form_for(User.new(name: 1), url: "/") do |form|
      assert_dom_equal <<~HTML, form.collection_radio_buttons(:name, users, :first, :last)
        <sl-radio-group no-fieldset="true">
          <sl-radio name="user[name]" value="1" id="user_name_1" checked="checked">Yuki Nishijima</sl-radio>
          <sl-radio name="user[name]" value="2" id="user_name_2">Matz</sl-radio>
          <sl-radio name="user[name]" value="3" id="user_name_3">Koichi Sasada</sl-radio>
        </sl-radio-group>
      HTML
    end
  end

  test "#submit" do
    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.submit("Save")
        <sl-button submit="true" type="primary" data-disable-with="Save">Save</sl-button>
      HTML
    end
  end
end
