ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"
require "action_dispatch/system_testing/server"
require "shoelace/testing"

class ActiveSupport::TestCase
  parallelize workers: :number_of_processors
end

Capybara.server = :webrick

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
  include Shoelace::Testing

  if ENV['BROWSERSTACK_URL'].present?
    browserstack_url = URI(ENV['BROWSERSTACK_URL'])
    browserstack_url.user = ENV['BROWSERSTACK_USERNAME'] if ENV['BROWSERSTACK_USERNAME']
    browserstack_url.password = ENV['BROWSERSTACK_ACCESS_KEY'] if ENV['BROWSERSTACK_ACCESS_KEY']

    os, os_version, browser, browser_version =
      ENV.fetch('TARGET_BROWSER', 'Windows, 10, Edge, latest').split(", ")

    caps = Selenium::WebDriver::Remote::Capabilities.new(
      name: "Shoelace Rails",
      server: browserstack_url.host,
      user: browserstack_url.user,
      key: browserstack_url.password,
      os: os,
      os_version: os_version,
      browser: browser,
      browser_version: browser_version,
      "browserstack.local": true,
      "browserstack.debug": true,
      "browserstack.networkLogs": true,
      "browserstack.console": "errors",
    )

    driven_by :selenium, using: :remote, options: { url: browserstack_url.to_s, capabilities: caps }
  else
    driven_by :selenium, using: (ENV["JS_DRIVER"] || :headless_chrome).downcase.to_sym, screen_size: [1400, 1400]
  end

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
