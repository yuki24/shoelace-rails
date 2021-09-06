require "test_helper"

class SlFormTest < ApplicationSystemTestCase
  test "It can submit a form with a POST method" do
    visit new_user_path
    shadow_fill_in 'sl-input[label="Name"]', with: "Yuki Nishijima"
    shadow_fill_in 'sl-range[name="user[score]"]', with: "50"

    # sl_select from: "label"
    find('sl-radio', text: "New York").click

    # sl_select (single)
    find('sl-select[placeholder="Select one"]').click
    within find('sl-select[placeholder="Select one"]') do
      find('sl-menu-item', text: "Tokyo").click
    end

    # sl_select (multiple)
    find('sl-select[placeholder="Select two or more"]').click
    within find('sl-select[placeholder="Select two or more"]') do
      find('sl-menu-item', text: "Tokyo").click
      find('sl-menu-item', text: "New York").click
    end
    find('sl-select[placeholder="Select two or more"]').click

    # sl_check
    find("sl-checkbox").click

    # sl_toggle
    find("sl-switch").click

    shadow_fill_in 'sl-textarea[name="user[description]"]', "textarea", with: "I am a human."

    find("sl-button", text: "Create User").click

    assert_current_path users_path
    assert_text "Name: Yuki Nishijima"
    assert_text "Description: I am a human."
    assert_text "Color: #ffffff"
    assert_text "Score: 50"
    # assert_text "Current City:"
    assert_text "Previous City: tokyo"
    assert_text 'Past Cities: ["tokyo", "new_york"]'
    assert_text "Remember Me: 1"
    assert_text "Subscribe To Emails: 1"
  end
end
