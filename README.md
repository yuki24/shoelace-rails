# Shoelace Rails

The `shoelace-rails` gem adds useful helper methods for [Shoelace.style](https://shoelace.style), the design system.

## Installation

This document assumes that you use the [webpacker](https://github.com/rails/webpacker) gem. You may have to tweak the
examples here if you do not use it. However, the principle here should be the same regardless of the JS bundler you
use.

Add this line to your application's Gemfile:

```ruby
gem 'shoelace-rails', git: "https://github.com/yuki24/shoelace-rails.git"
```

And then execute:

```
$ bundle install
```

Additionally, you need to add the following npm packages:

```sh
yarn add @shoelace-style/shoelace @yuki24/shoelace-rails copy-webpack-plugin
```

## Set up CSS

### Asset Pipeline

Add the following lines to the `app/assets/stylesheets/application.css` if you need the sprockets gem:

```scss
/*
 *= require "@shoelace-style/shoelace/dist/themes/light.css
 *= require "@shoelace-style/shoelace/dist/themes/dark.css
 */
```

### Webpack & CSS Loader

Add the following lines to the `app/packs/entrypoints/application.js` if you prefer the webpack and CSS loader:

```js
import "@shoelace-style/shoelace/dist/themes/light.css"
import "@shoelace-style/shoelace/dist/themes/dark.css" // Optional dark mode
```

## Set up Javascript

Add the code below so Shoelace's assets (mostly icons) will be copied to the final build output. This is required for
both Turbolinks and Hotwire.

```js
// config/webpack/environment.js
const { environment } = require('@rails/webpacker')
const path = require('path')
const CopyPlugin = require('copy-webpack-plugin')

// Add shoelace icons to webpack's build process
environment.plugins.append(
  'CopyPlugin',
  new CopyPlugin({
    patterns: [
      {
        from: path.resolve(__dirname, '../../node_modules/@shoelace-style/shoelace/dist/assets'),
        to: path.resolve(__dirname, '../../public/packs/js/assets')
      }
    ]
  })
)

module.exports = environment
```

### Turbolinks 5

If you are using [the traditional Turbolinks 5](https://github.com/turbolinks/turbolinks), import the `startUjs` and
`startTurbolinks` functions to activate Shoelace UJS in the `app/packs/entrypoints/application.js`, or the entrypoint
file of your project:

```js
import Turbolinks from "turbolinks"
import { setBasePath } from "@shoelace-style/shoelace"
import { startUjs, startTurbolinks, getDefaultAssetPath } from "@yuki24/shoelace-rails"

// Important! Turboinks.start() needs to be called before calling the startTurbolinks function:
Turbolinks.start()

startUjs()
startTurbolinks(Turbolinks)
setBasePath(getDefaultAssetPath())
```

This gem provides form helpers called `sl_form_for`, `sl_form_with` and `sl_form_tag`. When rendering a form, try
using one of them just like you normally use `form_for`:

```erb
<%= sl_form_for @user do |form| %>
  ...
<% end %>
```

Once the Shoelace UJS is activated and the form is rendered by `sl_form_for` (or any equivalent form helper), form
submission should automatically be handled and you should be able to start buildgin an app like you normally do on
Rails.

### Hotwire

If you are using [Hotwire](https://hotwired.dev/), import the `startTurbo` function in the
`app/packs/entrypoints/application.js`, or the entrypoint file of your project:

```js
import "@hotwired/turbo-rails"
import { setBasePath } from "@shoelace-style/shoelace"
import { startTurbo, getDefaultAssetPath } from "@yuki24/shoelace-rails"

startTurbo()
setBasePath(getDefaultAssetPath())
```

Unlike the Turbolinks support, you have to use the other form helper, called `sl_turbo_form_for`:

```erb
<%= sl_turbo_form_for @user do |form| %>
  ...
<% end %>
```

There are also corresponding `sl_turbo_form_with` and `sl_turbo_form_tag` methods in case you need to render a form
in different scenarios. You can still use methods like `sl_form_for`, but the `sl-submit` event is not automatically
handled.

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

## How it works

[Shoelace.style](https://shoelace.style/) is built of top of the
[Web Components](https://developer.mozilla.org/en-US/docs/Web/Web_Components) API, which provides a way to
[your own HTML elements](https://html.spec.whatwg.org/multipage/custom-elements.html) and use them in any framework,
or even in a static HTML.

This is a great way to build a design system, but it also comes with a few challenges. One notable challenge is form
submissions. Because of how Shoelace is built (for a good reason), the native `<form>` element does not recognize
Shoelace form controls like `<sl-input>`. The library solves this problem by providing a bridge that connects Shoelace
with Turbolinks and Hotwire.

### How Turbolinks support works

Simply put, the Rails UJS is just [a bunch of custom event handlers](https://github.com/rails/rails/blob/c2b701e33470adb1fab15c5e68957facdb26ebb1/actionview/app/assets/javascripts/rails-ujs/start.coffee#L34-L71).
Because of the reasons described above, the normal form `submit` event is not emitted by the `<sl-form>` element.
Aside from that, the commonly used technique of making a POST/DELETE request with `data-confirm="You are you sure?""`
only targets the `<a>` and `<button>` tags, and it does not work with Shoelace elements like `<sl-button>`. Here are
how these problems are addressed: 

1. **Form submission**: when a button within the form is clicked, Shoelace emits a `sl-submit`
   event with access to [the `formdata` object](https://developer.mozilla.org/en-US/docs/Web/API/FormData). The
   Shoelace UJS [captures this event](https://github.com/yuki24/shoelace-rails/blob/92b7502c267189ef89087c1e2a633bd47f8bce9b/src/turbolinks/start.ts#L26-L28)
   and [does the same thing as Rails UJS](https://github.com/yuki24/shoelace-rails/blob/92b7502c267189ef89087c1e2a633bd47f8bce9b/src/turbolinks/features/remote.ts#L13-L76).
3. **Event listeners for Shoelace elements**: the Shoelace UJS adds an event listener that is similar to the original
Rails UJS, but [specifically targets the `<sl-button>` element](https://github.com/yuki24/shoelace-rails/blob/92b7502c267189ef89087c1e2a633bd47f8bce9b/src/turbolinks/start.ts#L20-L24).

Turbolinks is actually mostly compatible with Shoelace. The only notable addition is support for links within a
[Shadow DOM](https://developer.mozilla.org/en-US/docs/Web/Web_Components/Using_shadow_DOM). This may not necessarily
eb an issue specifically with Shoelace, and other implementations that use the Shadow DOM may benefit from
[this fix](https://github.com/yuki24/shoelace-rails/blob/92b7502c267189ef89087c1e2a633bd47f8bce9b/src/turbolinks/turbolinks.ts#L36-L52).

### How Hotwire support works

As explained above, the normal form `submit` events are not emitted. On the other hand, Hotwire is a complete write
of Turbolinks, and the hacks for Turbolinks 5 may not work for Hotwire. Thankfully, Hotwire has received a lot of
improvements, and the amount of hacks required to make it work on Rails was very minimal, most notably:

  1. All link transitions work with Turbo Drive with no extra code.
  2. Stimulus.js is fully compatible with [synthetic events](https://developer.mozilla.org/en-US/docs/Web/Events/Creating_and_triggering_events),
     which Shoelace also uses to emit its events.

Rails UJS is no longer a dependency and form submission is now also handled by Hotwire Turbo, which leaves us in a
quite good place to make Shoelace work with Rails. That means all we have to do is to translate the `sl-submit` event
in to the `submit` event.

In order to simulate a normal form submission performed by a form, the `startTurbo()` function defines a custom
element called [`<sl-turbo-form>`](https://github.com/yuki24/shoelace-rails/blob/main/src/turbo/sl-turbo-form.ts).
This element internally maintains two things: a `<sl-form>` element [rendered in the element's Shadow DOM](https://github.com/yuki24/shoelace-rails/blob/31711035c4b190a58fec2eaefafb88e8fa022ba4/src/turbo/sl-turbo-form.ts#L41-L43),
and a `<form>` tag rendered in [the light DOM](https://github.com/yuki24/shoelace-rails/blob/31711035c4b190a58fec2eaefafb88e8fa022ba4/src/turbo/sl-turbo-form.ts#L60-L63).
When the `sl-submit` event is captured, the element will populate the `form` element in the light DOM with the
`formdata` provided by the `sl_submit` event, and emits an synthetic `submit` event. Once this is fired, everything
will be handled by Hotwire Turbo.

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
