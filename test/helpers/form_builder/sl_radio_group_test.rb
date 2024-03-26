# frozen_string_literal: true
require 'test_helper'

require_relative '../../../app/helpers/shoelace/sl_form_helper'

class FormBuilderSlRadioGroupTest < ActionView::TestCase
  include Shoelace::SlFormHelper

  test "#collection_radio_buttons" do
    users = {
      1 => "Yuki Nishijima",
      2 => "Matz",
      3 => "Koichi Sasada",
    }

    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.collection_radio_buttons(:name, users, :first, :last)
        <sl-radio-group label="Name" name="user[name]" id="user_name">
          <sl-radio value="1" id="user_name_1">Yuki Nishijima</sl-radio>
          <sl-radio value="2" id="user_name_2">Matz</sl-radio>
          <sl-radio value="3" id="user_name_3">Koichi Sasada</sl-radio>
        </sl-radio-group>
      HTML
    end
  end

  test "#collection_radio_buttons with an invalid value" do
    yuki = User.new.tap(&:validate)
    users = {
      1 => "Yuki Nishijima",
      2 => "Matz",
      3 => "Koichi Sasada",
    }

    sl_form_for(yuki, url: "/") do |form|
      assert_dom_equal <<~HTML, form.collection_radio_buttons(:name, users, :first, :last)
        <sl-radio-group label="Name" name="user[name]" id="user_name" data-invalid="" invalid="">
          <sl-radio value="1" id="user_name_1">Yuki Nishijima</sl-radio>
          <sl-radio value="2" id="user_name_2">Matz</sl-radio>
          <sl-radio value="3" id="user_name_3">Koichi Sasada</sl-radio>
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
        <sl-radio-group label="Name" name="user[name]" value="1" id="user_name">
          <sl-radio value="1" id="user_name_1">Yuki Nishijima</sl-radio>
          <sl-radio value="2" id="user_name_2">Matz</sl-radio>
          <sl-radio value="3" id="user_name_3">Koichi Sasada</sl-radio>
        </sl-radio-group>
      HTML
    end
  end
end
