# frozen_string_literal: true
require 'test_helper'

require_relative '../../../app/helpers/shoelace/sl_form_helper'

class FormBuilderSlSelectTest < ActionView::TestCase
  include Shoelace::SlFormHelper

  test "#select" do
    users = {
      "Yuki Nishijima" => 1,
      "Matz" => 2,
      "Koichi Sasada" => 3
    }

    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.select(:name, users)
        <sl-select label="Name" name="user[name]" id="user_name">
          <sl-option value="1">Yuki Nishijima</sl-option>
          <sl-option value="2">Matz</sl-option>
          <sl-option value="3">Koichi Sasada</sl-option>
        </sl-select>
      HTML
    end
  end

  test "#select with an invalid value" do
    yuki = User.new.tap(&:validate)
    users = {
      "Yuki Nishijima" => 1,
      "Matz" => 2,
      "Koichi Sasada" => 3
    }

    sl_form_for(yuki, url: "/") do |form|
      assert_dom_equal <<~HTML, form.select(:name, users)
        <sl-select label="Name" name="user[name]" id="user_name" data-invalid="" invalid="">
          <sl-option value="1">Yuki Nishijima</sl-option>
          <sl-option value="2">Matz</sl-option>
          <sl-option value="3">Koichi Sasada</sl-option>
        </sl-select>
      HTML
    end
  end

  test "#select with a default help text block" do
    with_default_input_slot_method do
      sl_form_for(User.new, url: "/") do |form|
        assert_dom_equal <<~HTML, form.select(:name, "Yuki Nishijima" => 1)
          <sl-select label="Name" name="user[name]" id="user_name">
            <sl-option value="1">Yuki Nishijima</sl-option>
            <div slot="help-text">Help text for name</div>
          </sl-select>
        HTML
      end
    end
  end

  test "#select with a block that does not return anything" do
    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.select(:name, "Yuki Nishijima" => 1) { }
        <sl-select label="Name" name="user[name]" id="user_name">
          <sl-option value="1">Yuki Nishijima</sl-option>
        </sl-select>
      HTML
    end
  end

  test "#select with a custom value" do
    users = {
      "Yuki Nishijima" => 1,
      "Matz" => 2,
      "Koichi Sasada" => 3
    }

    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.select(:name, users, {}, { value: 3 })
        <sl-select label="Name" value="3" name="user[name]" id="user_name">
          <sl-option value="1">Yuki Nishijima</sl-option>
          <sl-option value="2">Matz</sl-option>
          <sl-option value="3">Koichi Sasada</sl-option>
        </sl-select>
      HTML
    end
  end

  test "#select with custom selected and disabled values" do
    users = {
      "Yuki Nishijima" => 1,
      "Matz" => 2,
      "Koichi Sasada" => 3
    }

    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.select(:name, users, selected: 3, disabled: 1)
        <sl-select label="Name" name="user[name]" id="user_name">
          <sl-option value="1" disabled="disabled">Yuki Nishijima</sl-option>
          <sl-option value="2">Matz</sl-option>
          <sl-option value="3" checked="checked">Koichi Sasada</sl-option>
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
        <sl-select label="Name" name="user[name][]" id="user_name" multiple="multiple">
          <sl-option value="1">Yuki Nishijima</sl-option>
          <sl-option value="2">Matz</sl-option>
          <sl-option value="3">Koichi Sasada</sl-option>
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
        <sl-select label="Name" name="user[name]" id="user_name">
          <small>Main maintainers</small>
          <sl-option value="2">Matz</sl-option>
          <sl-option value="3">Koichi Sasada</sl-option>
          <sl-divider></sl-divider>
          <small>Default gem maintainers</small>
          <sl-option value="1">Yuki Nishijima</sl-option>
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

    sl_form_for(User.new(name: 2), url: "/") do |form|
      assert_dom_equal <<~HTML, form.select(:name, users)
        <sl-select label="Name" name="user[name]" id="user_name" value="2">
          <small>Main maintainers</small>
          <sl-option value="2" checked="checked">Matz</sl-option>
          <sl-option value="3">Koichi Sasada</sl-option>
          <sl-divider></sl-divider>
          <small>Default gem maintainers</small>
          <sl-option value="1">Yuki Nishijima</sl-option>
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
        <sl-select label="Name" name="user[name]" id="user_name">
          <sl-option value="1">Yuki Nishijima</sl-option>
          <sl-option value="2">Matz</sl-option>
          <sl-option value="3">Koichi Sasada</sl-option>
        </sl-select>
      HTML
    end
  end

  test "#collection_select with a default help text block" do
    with_default_input_slot_method do
      sl_form_for(User.new, url: "/") do |form|
        assert_dom_equal <<~HTML, form.collection_select(:name, { 1 => "Yuki Nishijima" }, :first, :last)
          <sl-select label="Name" name="user[name]" id="user_name">
            <sl-option value="1">Yuki Nishijima</sl-option>
            <div slot="help-text">Help text for name </div>
          </sl-select>
        HTML
      end
    end
  end

  test "#collection_select with an invalid value" do
    yuki = User.new.tap(&:validate)
    users = {
      1 => "Yuki Nishijima",
      2 => "Matz",
      3 => "Koichi Sasada",
    }

    sl_form_for(yuki, url: "/") do |form|
      assert_dom_equal <<~HTML, form.collection_select(:name, users, :first, :last)
        <sl-select label="Name" name="user[name]" id="user_name" data-invalid="" invalid="">
          <sl-option value="1">Yuki Nishijima</sl-option>
          <sl-option value="2">Matz</sl-option>
          <sl-option value="3">Koichi Sasada</sl-option>
        </sl-select>
      HTML
    end
  end

  test "#collection_select with a default value" do
    users = {
      1 => "Yuki Nishijima",
      2 => "Matz",
      3 => "Koichi Sasada",
    }

    sl_form_for(User.new(name: "2"), url: "/") do |form|
      assert_dom_equal <<~HTML, form.collection_select(:name, users, :first, :last)
        <sl-select label="Name" name="user[name]" id="user_name" value="2">
          <sl-option value="1">Yuki Nishijima</sl-option>
          <sl-option value="2" checked="checked">Matz</sl-option>
          <sl-option value="3">Koichi Sasada</sl-option>
        </sl-select>
      HTML
    end
  end

  test "#grouped_collection_select" do
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
        <sl-select label="Name" name="user[name]" id="user_name" value="2">
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

  test "#grouped_collection_select with a default help text block" do
    users = [
      OpenStruct.new(
        group_name: "Default gem maintainers",
        members: [OpenStruct.new(id: 3, name: "Yuki Nishijima")]
      ),
    ]

    with_default_input_slot_method do
      sl_form_for(User.new(name: "2"), url: "/") do |form|
        assert_dom_equal <<~HTML, form.grouped_collection_select(:name, users, :members, :group_name, :id, :name)
          <sl-select label="Name" name="user[name]" id="user_name" value="2">
            <small>Default gem maintainers</small>
            <sl-option value="3">Yuki Nishijima</sl-option>
            <div slot="help-text">Help text for name 2</div>
          </sl-select>
        HTML
      end
    end
  end

  test "#grouped_collection_select with an invalid value" do
    yuki = User.new.tap(&:validate)
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

    sl_form_for(yuki, url: "/") do |form|
      assert_dom_equal <<~HTML, form.grouped_collection_select(:name, users, :members, :group_name, :id, :name)
        <sl-select label="Name" name="user[name]" id="user_name" data-invalid="" invalid="">
          <small>Main maintainers</small>
          <sl-option value="1">Matz</sl-option>
          <sl-option value="2">Koichi Sasada</sl-option>
          <sl-divider></sl-divider>
          <small>Default gem maintainers</small>
          <sl-option value="3">Yuki Nishijima</sl-option>
        </sl-select>
      HTML
    end
  end
end
