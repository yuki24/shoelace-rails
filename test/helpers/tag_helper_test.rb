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

    assert_dom_equal <<~HTML, sl_button_to("Next", "/next", class: "mt-1")
      <sl-button href="/next" class="mt-1">Next</sl-button>
    HTML

    assert_dom_equal(<<~HTML, sl_button_to("/next") { "Next" })
      <sl-button href="/next">Next</sl-button>
    HTML

    assert_dom_equal(<<~HTML, sl_button_to("/next", class: "mt-1") { "Next" })
      <sl-button href="/next" class="mt-1">Next</sl-button>
    HTML

    assert_dom_equal <<~HTML, sl_button_to("Next")
      <sl-button>Next</sl-button>
    HTML
  end

  test "#sl_icon_tag"do
    assert_dom_equal <<~HTML, sl_icon_tag("0-circle-fill")
      <sl-icon name="0-circle-fill"></sl-icon>
    HTML

    assert_dom_equal <<~HTML, sl_icon_tag("0-circle-fill", slot: "icon")
      <sl-icon name="0-circle-fill" slot="icon"></sl-icon>
    HTML
  end

  test "#sl_avatar_tag"do
    assert_dom_equal <<~HTML, sl_avatar_tag("/path/to/image.jpg")
      <sl-avatar image="/path/to/image.jpg"></sl-avatar>
    HTML

    assert_dom_equal(<<~HTML, sl_avatar_tag("/path/to/image.jpg", slot: "trigger") { "Body" })
      <sl-avatar image="/path/to/image.jpg" slot="trigger">
        Body
      </sl-avatar>
    HTML
  end
end
