# Shoelace Rails

The `shoelace-rails` gem adds useful helper methods for https://shoelace.style, the design system.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'shoelace-rails', git: "https://github.com/yuki24/shoelace-rails.git"
```

And then execute:

```
$ bundle install
```

## Form Helpers

Normally, we use Rails form helpers such as `form_for`, `form_with` and `form_tag`. This gem provides drop-in
replacements for them, such as `sl_form_for`, `sl_form_with` and `sl_form_tag`. For example, this code:

```erb
<%= sl_form_for @user do |form| %>
  <%# Text input: https://shoelace.style/components/input %>
  <%= form.text_field :name %>
  <%= form.password_field :password, placeholder: "Password Toggle", 'toggle-password': true %>

  <%# Radio buttons: https://shoelace.style/components/color-picker %>
  <%= form.color_field :color %>

  <%# Radio buttons: https://shoelace.style/components/radio %>
  <%= form.collection_radio_buttons :status, { id_1: "Option 1", id_2: "Option 2", id_3: "Option 3" }, :first, :last %>

  <%# Select: https://shoelace.style/components/select %>
  <%= form.collection_select :tag, { id_1: "Option 1", id_2: "Option 2", id_3: "Option 3" }, :first, :last, {}, { placeholder: "Select one" } %>

  <%= form.submit %>
<% end %>
```

will produce:

```html
<sl-form class="new_user" id="new_user" data-remote="true" action="/" accept-charset="UTF-8" method="post">
  <sl-input label="Name" type="text" name="user[name]" id="user_name"></sl-input>
  <sl-input label="Password" type="password" name="user[password]" id="user_password"></sl-input>
  <sl-color-picker value="#ffffff" name="user[color]" id="user_color"></sl-color-picker>

  <sl-radio-group no-fieldset="true">
    <sl-radio value="id_1" name="user[status]" id="user_status_id_1">Option 1</sl-radio>
    <sl-radio value="id_2" name="user[status]" id="user_status_id_2">Option 2</sl-radio>
    <sl-radio value="id_3" name="user[status]" id="user_status_id_3">Option 3</sl-radio>
  </sl-radio-group>

  <sl-select placeholder="Select one" name="user[tag]" id="user_tag">
    <sl-menu-item value="id_1">Option 1</sl-menu-item>
    <sl-menu-item value="id_2">Option 2</sl-menu-item>
    <sl-menu-item value="id_3">Option 3</sl-menu-item>
  </sl-select>

  <sl-button submit="true" type="primary" data-disable-with="Create User">Create User</sl-button>
</sl-form>
```

## Setting up Shoelace

The official documentation for [Integrating with Rails](https://shoelace.style/tutorials/integrating-with-rails) is a
great place to start with. It is recommended to follow the official guide before setting up the Shoelace Rails UJS.

### Handling form submission

By default, native `<form>` elements will not recognize Shoelace form controls. The `<sl-form>` component solves this
problem by serializing both Shoelace form controls and native form controls when the form is submitted. Unfortunately,
it would not work with the `rails-ujs`, and you would have to handle form submissions on your own. The Shoelace
Rails UJS solves this problem by providing bindings that are similar to the original rails UJS.

```sh
yarn add @yuki24/shoelace-rails --registry https://npm.pkg.github.com/
```

Once it is added to the project's `package.json`, add the following code to the `application.js`, or the entrypoint
file of your project:

```js
import Turbolinks from "turbolinks"
import { startUjs, startTurbolinks } from "@yuki24/shoelace-rails"

startUjs()

// Important! Turboinks.start() needs to be called before calling the startTurbolinks function:
Turbolinks.start()
startTurbolinks(Turbolinks)
```

You are all set! Now form submissions should be handled automatically.

### Hotwire Support

The Hotwire support is actively being worked on and will be in beta soon.

## Development

 1. Run `bundle install`
 2. Make a change and add test coverage
 3. Run `bundle rails test`
 4. Make a commit and push it to GitHub
 5. Send us a pull request

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/shoelace-rails. This project is
intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the
[code of conduct](https://github.com/[USERNAME]/shoelace-rails/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Shoelace::Rails project's codebases, issue trackers, chat rooms and mailing lists is
expected to follow the [code of conduct](https://github.com/[USERNAME]/shoelace-rails/blob/master/CODE_OF_CONDUCT.md).
