# Shoelace Rails

The `shoelace-rails` gem adds useful helper methods for [Shoelace.style](https://shoelace.style), the design system.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'shoelace-rails'
```

And then execute:

```
$ bundle install
```

Additionally, you need to add the following npm packages:

```sh
$ yarn add @shoelace-style/shoelace
```

## Set up CSS

### Asset Pipeline

Add the following lines to the `app/assets/stylesheets/application.css` if you need the sprockets gem:

```scss
/*
 *= require @shoelace-style/shoelace/dist/themes/light.css
 *= require @shoelace-style/shoelace/dist/themes/dark.css
 */
```

### Webpack & CSS Loader

Add the following lines to the `app/packs/entrypoints/application.js` if you prefer the webpack and CSS loader:

```js
import "@shoelace-style/shoelace/dist/themes/light.css"
import "@shoelace-style/shoelace/dist/themes/dark.css" // Optional dark mode
```

## Set up Javascript

In this README, it is assumed that you are using a JS bundler such as `webpack` or `esbuild`. In order to define all
the custome elements,  import the shoelace dependency in the entrypoint file:

```js
import "@shoelace-style/shoelace"
```

That's it!

### Shoelace Icons

Shoelace icons are automatically set up to load properly, so you don't need to add any extra code. More specifically,

 * In development, the icons are served by the `ActionDispatch::Static` middleware, directly from the
   `node_modules/@shoelace-style/shoelace/dist/assets/icons` directory.
 * In production, the icon files are automatically copied into the `public/assets` directory as part of the
   `assets:precompile` rake task.

## View Helpers

As explained above, this gem provides drop-in replacements to. Here is a short example of how the form helper works:

```erb
<%= sl_form_for @user do |form| %>
  <%  # Text input: https://shoelace.style/components/input %>
  <%= form.text_field :name %>
  <%= form.password_field :password, placeholder: "Password Toggle", 'toggle-password': true %>

  <%  # Radio buttons: https://shoelace.style/components/color-picker %>
  <%= form.color_field :color %>

  <%  # Radio buttons: https://shoelace.style/components/radio %>
  <%= form.collection_radio_buttons :status, { id_1: "Option 1", id_2: "Option 2", id_3: "Option 3" }, :first, :last %>

  <%  # Select: https://shoelace.style/components/select %>
  <%= form.collection_select :tag, { id_1: "Option 1", id_2: "Option 2", id_3: "Option 3" }, :first, :last, {}, { placeholder: "Select one" } %>

  <%= form.submit %>
<% end %>
```

And this code will produce:

```html
<form class="new_user" id="new_user" data-remote="true" action="/" accept-charset="UTF-8" method="post">
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
</form>
```

## Development

 1. Run `bundle install`
 2. Make a change and add test coverage
 3. Run `bundle rails test`
 4. Make a commit and push it to GitHub
 5. Send us a pull request

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yuki24/shoelace-rails. This project is
intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the
[code of conduct](https://github.com/yuki24/shoelace-rails/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Shoelace::Rails project's codebases, issue trackers, chat rooms and mailing lists is
expected to follow the [code of conduct](https://github.com/yuki24/shoelace-rails/blob/master/CODE_OF_CONDUCT.md).
