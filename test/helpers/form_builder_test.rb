# frozen_string_literal: true
require 'test_helper'

require_relative '../../app/helpers/shoelace/sl_form_builder'

class FormBuilderTest < ActionView::TestCase
  include Shoelace::SlFormHelper

  test "#submit" do
    sl_form_for(User.new, url: "/") do |form|
      assert_dom_equal <<~HTML, form.submit("Save")
        <sl-button type="submit" variant="primary" data-disable-with="Save">Save</sl-button>
      HTML
    end
  end
end
