require "test_helper"

class HotwireFormTest < ApplicationSystemTestCase
  setup do
    visit new_hotwire_form_path
  end

  test "It can submit a form with a POST method" do
    shadow_fill_in 'sl-input[label="Name"]', with: "Yuki Nishijima"
    shadow_fill_in 'sl-range[name="user[score]"]', with: "50"

    find('sl-radio', text: "New York").click # Selecting a radio button does not work...

    sl_select "Tokyo", from: "Select one"
    sl_multi_select "Tokyo", "New York", from: "Select two or more"
    sl_check "Remember me"
    sl_toggle "Subscribe to emails"
    shadow_fill_in 'sl-textarea[name="user[description]"]', "textarea", with: "I am a human."

    find("sl-button", text: "Create User").click

    assert_current_path hotwire_form_path(1)
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

  test "It can submit a form with a POST method without asynchronous submission" do
    shadow_fill_in 'sl-input[label="Name"]', with: "Yuki Nishijima"
    shadow_fill_in 'sl-range[name="user[score]"]', with: "50"

    find('sl-radio', text: "New York").click # Selecting a radio button does not work...

    sl_select "Tokyo", from: "Select one"
    sl_multi_select "Tokyo", "New York", from: "Select two or more"
    sl_check "Remember me"
    sl_toggle "Subscribe to emails"
    shadow_fill_in 'sl-textarea[name="user[description]"]', "textarea", with: "I am a human."

    find("sl-button", text: "Submit without Turbo").click

    assert_current_path hotwire_form_path(1)
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

  test "It can handle an error form submission" do
    find("sl-button", text: "Create User").click

    assert_text "Name can't be blank"
  end
end
