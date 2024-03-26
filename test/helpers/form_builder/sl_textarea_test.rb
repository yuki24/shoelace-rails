# frozen_string_literal: true
require 'test_helper'

require_relative '../../../app/helpers/shoelace/sl_form_helper'

class FormBuilderSlTextareaTest < ActionView::TestCase
  include Shoelace::SlFormHelper

  test "#text_area" do
    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.text_area(:name)
        <sl-textarea label="Name" resize="auto" name="user[name]" id="user_name"></sl-textarea>
      HTML
    end
  end

  test "#text_area with an invalid value" do
    yuki = User.new.tap(&:validate)

    sl_form_for(yuki, url: "/") do |form|
      assert_dom_equal <<~HTML, form.text_area(:name)
        <sl-textarea label="Name" resize="auto" name="user[name]" id="user_name" data-invalid="" invalid=""></sl-textarea>
      HTML
    end
  end

  test "#text_area with a value" do
    sl_form_for(User.new(name: "Yuki Nishijima"), url: "/") do |form|
      assert_dom_equal <<~HTML, form.text_area(:name)
        <sl-textarea label="Name" resize="auto" value="Yuki Nishijima" name="user[name]" id="user_name"></sl-textarea>
      HTML
    end
  end

  test "#text_area with an one-off value" do
    sl_form_for(User.new(name: "Yuki Nishijima"), url: "/") do |form|
      assert_dom_equal <<~HTML, form.text_area(:name, value: "Yuki")
        <sl-textarea label="Name" resize="auto" value="Yuki" name="user[name]" id="user_name"></sl-textarea>
      HTML
    end
  end

  test "#text_area without a label" do
    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.text_area(:name, label: nil)
        <sl-textarea resize="auto" name="user[name]" id="user_name"></sl-textarea>
      HTML
    end
  end

  test "#text_area with a size" do
    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.text_area(:name, size: "small")
        <sl-textarea label="Name" resize="auto" size="small" name="user[name]" id="user_name"></sl-textarea>
      HTML
    end
  end

  test "#text_area with a block" do
    sl_form_for(User.new, url: "/") do |form|
      expected = <<~HTML
        <sl-textarea label="Name" resize="auto" name="user[name]" id="user_name">
          <div slot="help-text">Name can not be blank.</div>
        </sl-textarea>
      HTML

      assert_dom_equal(expected, form.text_area(:name) {
        content_tag(:div, "Name can not be blank.", slot: "help-text")
      })
    end
  end
end
