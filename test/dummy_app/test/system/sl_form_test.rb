require "test_helper"

class SlFormTest < ApplicationSystemTestCase
  test "It can submit a form" do
    visit new_user_path
    shadow_fill_in 'sl-input[label="Name"]', with: "Yuki Nishijima"
    find("sl-button", text: "Create User").click

    assert false
  end

  test "It can handle an error form submission" do
    assert false
  end

  test "It allows you to opt out of the Shoelace Rails UJS" do
    assert false
  end
end
