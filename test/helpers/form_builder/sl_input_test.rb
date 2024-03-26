# frozen_string_literal: true
require 'test_helper'

require_relative '../../../app/helpers/shoelace/sl_form_helper'

class FormBuilderSlInputTest < ActionView::TestCase
  include Shoelace::SlFormHelper

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

  test "#text_field with an invalid value" do
    yuki = User.new.tap(&:validate)

    sl_form_for(yuki, url: "/") do |form|
      assert_dom_equal <<~HTML, form.text_field(:name)
        <sl-input label="Name" type="text" name="user[name]" id="user_name" data-invalid="" invalid=""></sl-input>
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
end
