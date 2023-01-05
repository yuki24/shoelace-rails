# frozen_string_literal: true
require 'test_helper'

require_relative '../../app/helpers/shoelace/tag_helper'

class TagHelperTest < ActionView::TestCase
  include Shoelace::TagHelper

  test "#sl_button_tag" do
    assert_dom_equal(<<~HTML, sl_button_tag { "Submit" })
      <sl-button>Submit</sl-button>
    HTML
  end

  test "#sl_button_to" do
    assert_dom_equal <<~HTML, sl_button_to("Next", "/next")
      <sl-button href="/next">Next</sl-button>
    HTML

    assert_dom_equal(<<~HTML, sl_button_to("/next") { "Next" })
      <sl-button href="/next">Next</sl-button>
    HTML

    assert_dom_equal <<~HTML, sl_button_to("Next")
      <sl-button>Next</sl-button>
    HTML
  end
end
