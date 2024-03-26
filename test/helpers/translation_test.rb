# frozen_string_literal: true
require 'test_helper'

require_relative '../../app/helpers/shoelace/sl_form_builder'

class TranslationTest < ActionView::TestCase
  include ActionView::Helpers::TranslationHelper
  include Shoelace::SlFormHelper

  setup do
    I18n.backend.store_translations :en,
                                    helpers: {
                                      label: {
                                        user: { name: "Full Name" }
                                      }
                                    }

    view_paths = ActionController::Base.view_paths
    view_paths.each(&:clear_cache)
    @view = ::ActionView::Base.with_empty_template_cache.with_view_paths(view_paths, {})
  end

  teardown do
    I18n.backend.reload!
  end

  test "Form helpers should respect label translations" do
    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.text_field(:name)
        <sl-input label="Full Name" type="text" name="user[name]" id="user_name"></sl-input>
      HTML
    end
  end

  test "Form helpers should cast symbol object names to String" do
    sl_form_for(User.new, as: :user, url: "/") do |form|
      assert_dom_equal <<~HTML, form.text_field(:name)
        <sl-input label="Full Name" type="text" name="user[name]" id="user_name"></sl-input>
      HTML
    end
  end

  test "Form helpers should fall back to the humanize method when there is no matching translation" do
    I18n.backend.reload!

    sl_form_for(OpenStruct.new, as: :user, url: "/") do |form|
      assert_dom_equal <<~HTML, form.text_field(:name_eq)
        <sl-input label="Name eq" type="text" name="user[name_eq]" id="user_name_eq"></sl-input>
      HTML
    end
  end

  test "#color_field should respect label translations" do
    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.color_field(:name)
        <sl-color-picker name="user[name]" id="user_name" label="Full Name"></sl-color-picker>
      HTML
    end
  end

  test "#range_field should respect label translations" do
    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.range_field(:name)
        <sl-range label="Full Name" name="user[name]" id="user_name"></sl-range>
      HTML
    end
  end

  test "#switch_field should respect label translations" do
    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.switch_field(:name)
        <sl-switch name="user[name]" id="user_name">Full Name</sl-switch>
      HTML
    end
  end

  test "#text_area should respect label translations" do
    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.text_area(:name)
        <sl-textarea label="Full Name" resize="auto" name="user[name]" id="user_name"></sl-textarea>
      HTML
    end
  end

  test "#check_box should respect label translations" do
    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.check_box(:name)
        <input name="user[name]" type="hidden" value="0" #{AUTOCOMPLETE_ATTRIBUTE} />
        <sl-checkbox value="1" name="user[name]" id="user_name">Full Name</sl-checkbox>
      HTML
    end
  end

  test "#selec should respect label translationst" do
    users = {
      "Yuki Nishijima" => 1,
      "Matz" => 2,
      "Koichi Sasada" => 3
    }

    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.select(:name, users)
        <sl-select label="Full Name" name="user[name]" id="user_name">
          <sl-option value="1">Yuki Nishijima</sl-option>
          <sl-option value="2">Matz</sl-option>
          <sl-option value="3">Koichi Sasada</sl-option>
        </sl-select>
      HTML
    end
  end

  test "#collection_select should respect label translations" do
    users = {
      1 => "Yuki Nishijima",
      2 => "Matz",
      3 => "Koichi Sasada",
    }

    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.collection_select(:name, users, :first, :last)
        <sl-select label="Full Name" name="user[name]" id="user_name">
          <sl-option value="1">Yuki Nishijima</sl-option>
          <sl-option value="2">Matz</sl-option>
          <sl-option value="3">Koichi Sasada</sl-option>
        </sl-select>
      HTML
    end
  end

  test "#grouped_collection_select should respect label translations" do
    users = [
      OpenStruct.new(
        group_name: "Main maintainers",
        members: [
          OpenStruct.new(id: 1, name: "Matz"),
          OpenStruct.new(id: 2, name: "Koichi Sasada"),
        ]
      ),
      OpenStruct.new(
        group_name: "Default gem maintainers",
        members: [OpenStruct.new(id: 3, name: "Yuki Nishijima")]
      ),
    ]

    sl_form_for(User.new(name: "2"), url: "/") do |form|
      assert_dom_equal <<~HTML, form.grouped_collection_select(:name, users, :members, :group_name, :id, :name)
        <sl-select label="Full Name" name="user[name]" id="user_name" value="2">
          <small>Main maintainers</small>
          <sl-option value="1">Matz</sl-option>
          <sl-option value="2" checked="checked">Koichi Sasada</sl-option>
          <sl-divider></sl-divider>
          <small>Default gem maintainers</small>
          <sl-option value="3">Yuki Nishijima</sl-option>
        </sl-select>
      HTML
    end
  end

  test "#collection_radio_buttons should respect label translations" do
    users = {
      1 => "Yuki Nishijima",
      2 => "Matz",
      3 => "Koichi Sasada",
    }

    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.collection_radio_buttons(:name, users, :first, :last)
        <sl-radio-group label="Full Name" name="user[name]" id="user_name">
          <sl-radio value="1" id="user_name_1">Yuki Nishijima</sl-radio>
          <sl-radio value="2" id="user_name_2">Matz</sl-radio>
          <sl-radio value="3" id="user_name_3">Koichi Sasada</sl-radio>
        </sl-radio-group>
      HTML
    end
  end
end
