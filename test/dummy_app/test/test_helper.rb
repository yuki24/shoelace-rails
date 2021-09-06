ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"
require "action_dispatch/system_testing/server"

class ActiveSupport::TestCase
  parallelize workers: :number_of_processors
end

ActionDispatch::SystemTesting::Server.silence_puma = true

class Capybara::Node::ShadowRoot < Capybara::Node::Element
  def host
    evaluate_script("this.host")
  end

  def text(type = nil, normalize_ws: false)
    all("*")
      .map {|node| node.text(type, normalize_ws: normalize_ws) }
      .join
  end
end

module ShadowRootSupport
  # Adds a way to retrieve the shadow root object of an element.
  #
  # @example
  #
  #   within all("sl-input")[0].shadow_root do
  #     puts text
  #     assert_text "Email"
  #     fill_in "user[email]", with: "ynishijima@pivotal.io"
  #   end
  #
  def shadow_root
    root_node = evaluate_script("this.shadowRoot")

    Capybara::Node::ShadowRoot.new(session, root_node.base, nil, nil) if root_node
  end
end

Capybara::Node::Element.include ShadowRootSupport

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  def shadow_fill_in(shadow_host, *locators, with:, currently_with: nil, fill_options: {}, **find_options)
    shadow_host = shadow_host.respond_to?(:to_capybara_node) ? shadow_host.to_capybara_node : find(shadow_host)

    locators = ['input'] if locators.empty?
    locators
      .reduce(shadow_host.shadow_root) { |node, locator| node.find(locator).shadow_root || node.find(locator) }
      .set(with, **fill_options)
  end

  def dispatch_event(query_selector: , event: , detail: {}.to_json)
    execute_script(<<~JAVASCRIPT)
      document
        .querySelector('#{query_selector}')
        .dispatchEvent(new CustomEvent('#{event}', { detail: #{detail} }))
    JAVASCRIPT
  end
end
