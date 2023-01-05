## v0.3.0

_<sup>released at 2023-01-05 08:47:12 UTC</sup>_

#### Features

- No longer requires the `sl-form` component (`4fdbfa15`)
- The `#text_area` method now accepts a block (`5092dc1c`)
- Allow overriding the value attribute for `<sl-select>` (`1f38be73`)
- Auto-display labels whenever possible (`c1e3a950`)
- `<sl-select>` now always has a label by default (`f9fb5f0c`)
- Support Ruby 3.2 (`b286cbc1`)
- Add `#sl_button_to` (`e1bdedba`)
- Add `#sl_icon_tag` (`8a2187a2`)
- Add `#sl_avatar_tag` (`77dccdb2`)
- Allow using the `Shoelace::FormBuilder` in a cleaner way (`43dea330`)

#### Bug Fixes

- Fixes a bug where the gem rake tasks are not loaded (`115bfb3d`)
- Fixes a bug where values are not properly passed in to `<sl-textarea>` (`3d163845`)
- Make sure yarn install is always executed before copying shoelace assets (`98018a27`)
- Fixes a bug where the `@object` needs to respond to `#errors` (`bb981ed0`)
- Fixes a bug where the `size` attr is ignored by the `#text_area` method (`8bc4c378`)
- Fixes a bug where unchecked checkbox values are not captured (`dc658bea`)

## [v0.2.0](https://github.com/yuki24/shoelace-rails/tree/v0.2.0)

_<sup>released at 2022-06-24 05:14:01 UTC</sup>_

#### Features

- Do not require the `copy-webpack-plugin` to set up Shoelace so the gem works with any js bundler.

## [v0.1.0](https://github.com/yuki24/shoelace-rails/tree/v0.1.0)

_<sup>released at 2022-02-17 13:17:09 UTC</sup>_

First release!

