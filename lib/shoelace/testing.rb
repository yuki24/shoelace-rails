# frozen_string_literal: true

module Shoelace
  module Testing
    def sl_select(option_text, from: )
      select_element = find("sl-select[placeholder=\"#{from}\"]")
      select_element.click

      within select_element do
        find('sl-option', text: option_text).click
      end

      select_element
    end

    def sl_multi_select(*options_to_select, from: )
      select_element = find("sl-select[placeholder=\"#{from}\"]")

      select_element.click
      within select_element do
        options_to_select.each do |option_text|
          find('sl-option', text: option_text).click
        end
      end

      # The multi select does not close automatically, so need to click to close it.
      select_element.click if options_to_select.size > 1

      select_element
    end

    def sl_check(label)
      find("sl-checkbox", text: label).click
    end

    def sl_toggle(label)
      find("sl-switch", text: label).click
    end
  end
end
