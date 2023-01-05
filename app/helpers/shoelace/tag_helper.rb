# frozen_string_literal: true

module Shoelace
  module TagHelper
    # Creates a generic +<sl-button>+ element.
    def sl_button_tag(**attrs, &block)
      content_tag("sl-button", **attrs, &block)
    end

    # Creates an <sl-button> tag with the href value as the caption.
    def sl_button_to(body, href = nil, **attrs, &block)
      if block_given? && href.nil?
        sl_button_tag(href: body, **attrs, &block)
      else
        sl_button_tag(href: href) { body }
      end
    end

    def sl_icon_tag(name, **attrs)
      tag.sl_icon(name: name, **attrs)
    end
  end
end
