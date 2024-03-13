## v0.6.2

#### 🐞Bug Fixes

- Fixes a bug where form builders fail to render when it falls back to humanize the given method name

## [v0.6.1](https://github.com/yuki24/shoelace-rails/tree/v0.6.1)

_<sup>released at 2024-03-13 03:05:20 UTC</sup>_

#### 🐞Bug Fixes

- Fixes a bug where form builders fail to render with a string `:as` option

## [v0.6.0](https://github.com/yuki24/shoelace-rails/tree/v0.6.0)

_<sup>released at 2024-03-13 02:54:02 UTC</sup>_

#### ⭐️ Features

- Add the ability to use translations with form helpers ([<tt>626f271</tt>](https://github.com/yuki24/shoelace-rails/commit/626f271ca710dd48040907ff6a99e3bba6c5d57c))

## [v0.5.0](https://github.com/yuki24/shoelace-rails/tree/v0.5.0)

_<sup>released at 2024-03-09 08:54:30 UTC</sup>_

#### ⭐️ Features

- Add support for Ruby 3.3 ([<tt>399f255</tt>](https://github.com/yuki24/shoelace-rails/commit/399f25567f964d0ea2e250eba6db28a2bcd038a3))
- Add support for Rails 7.1 ([#4](https://github.com/yuki24/shoelace-rails/pull/4))
- Add `#grouped_collection_select` ([<tt>2b91023</tt>](https://github.com/yuki24/shoelace-rails/commit/2b91023d51e1d0a218f2102232241afa82aaf872))
- Make the `<sl-radio>` form helpers compatible with Shoelace [2.0.0-beta.80](https://shoelace.style/resources/changelog#id_2_0_0-beta_80) and above ([<tt>ef9a834</tt>](https://github.com/yuki24/shoelace-rails/commit/ef9a8345f2c5c921847aef15e19cf64a471d6473))

## [v0.4.1](https://github.com/yuki24/shoelace-rails/tree/v0.4.1)

_<sup>released at 2023-03-21 04:03:27 UTC</sup>_

#### 🐞Bug Fixes

- Fixes a bug where `FormHelper` may not be defined when someone loads `ActionView` too early ([<tt>d91ed3b</tt>](https://github.com/yuki24/shoelace-rails/commit/d91ed3b595c01ce2dfc471b12b14311e0660d3d7))
- Fixes a bug where the Shoelace rake tasks blow up when the project does not depend on Sprockets or Propshaft ([<tt>0e64cd6</tt>](https://github.com/yuki24/shoelace-rails/commit/0e64cd6dc38a037171be04eaf1d3f59c3c8529eb), [<tt>75adf83</tt>](https://github.com/yuki24/shoelace-rails/commit/75adf831b1faa7f5d1faeed26e672d4bc89b9513))

## [v0.4.0](https://github.com/yuki24/shoelace-rails/tree/v0.4.0)

_<sup>released at 2023-01-07 07:23:50 UTC</sup>_

#### 🚨 Breaking Changes

- No longer works with `2.0.0-beta.87` and below.

#### ⭐️ Features

- Support Shoelace.style `2.0.0-beta.88`.

## [v0.3.0](https://github.com/yuki24/shoelace-rails/tree/v0.3.0)

_<sup>released at 2023-01-05 08:49:23 UTC</sup>_

#### Features

- No longer requires the `sl-form` component ([<tt>4fdbfa1</tt>](https://github.com/yuki24/shoelace-rails/commit/4fdbfa15fa10db9e7240378ca34ebcc494d18f1a))
- The `#text_area` method now accepts a block ([<tt>5092dc1</tt>](https://github.com/yuki24/shoelace-rails/commit/5092dc1cbc7e8e74552451450804baa378ab1f11))
- Allow overriding the value attribute for `<sl-select>` ([<tt>1f38be7</tt>](https://github.com/yuki24/shoelace-rails/commit/1f38be73e3335c10e846393ebcf5155d155b00b2))
- Auto-display labels whenever possible ([<tt>c1e3a95</tt>](https://github.com/yuki24/shoelace-rails/commit/c1e3a950c3e8ac4238ed3e83e4d87467a68eb91f))
- `<sl-select>` now always has a label by default ([<tt>f9fb5f0</tt>](https://github.com/yuki24/shoelace-rails/commit/f9fb5f0cd74d179241be51510fa1c306481946c9))
- Support Ruby 3.2 ([<tt>b286cbc</tt>](https://github.com/yuki24/shoelace-rails/commit/b286cbc18930218ab5c82bd8648a51e9c6ce53db))
- Add `#sl_button_to` ([<tt>e1bdedb</tt>](https://github.com/yuki24/shoelace-rails/commit/e1bdedba4656d89a82c78641644490085da1fa37))
- Add `#sl_icon_tag` ([<tt>8a2187a</tt>](https://github.com/yuki24/shoelace-rails/commit/8a2187a2800771512fccf2c8231378a77be59df4))
- Add `#sl_avatar_tag` ([<tt>77dccdb</tt>](https://github.com/yuki24/shoelace-rails/commit/77dccdb24cfc014bd997ffb66ad89ff95afb3ef7))
- Allow using the `Shoelace::FormBuilder` in a cleaner way ([<tt>43dea33</tt>](https://github.com/yuki24/shoelace-rails/commit/43dea3309c3e0cf9d9b43b6957f6e54ad9497c9f))

#### Bug Fixes

- Fixes a bug where the gem rake tasks are not loaded ([<tt>115bfb3</tt>](https://github.com/yuki24/shoelace-rails/commit/115bfb3d81ca19b5b922a5fb32f46adb1d6e8544))
- Fixes a bug where values are not properly passed in to `<sl-textarea>` ([<tt>3d16384</tt>](https://github.com/yuki24/shoelace-rails/commit/3d16384554bd4a6143e28e483f8d6bee8fb2e073))
- Make sure yarn install is always executed before copying shoelace assets ([<tt>98018a2</tt>](https://github.com/yuki24/shoelace-rails/commit/98018a27a29ddc9ff2c2fa066bbe986709803a1d))
- Fixes a bug where the `@object` needs to respond to `#errors` ([<tt>bb981ed</tt>](https://github.com/yuki24/shoelace-rails/commit/bb981ed05825707cef89d70a7d1699c12cd0ba9b))
- Fixes a bug where the `size` attr is ignored by the `#text_area` method ([<tt>8bc4c37</tt>](https://github.com/yuki24/shoelace-rails/commit/8bc4c3784a458e7fc9c18a143578b2cbf588e9e7))
- Fixes a bug where unchecked checkbox values are not captured ([<tt>dc658be</tt>](https://github.com/yuki24/shoelace-rails/commit/dc658bea9fc4d4205dacdfe133b091c5a5edf14c))

## [v0.2.0](https://github.com/yuki24/shoelace-rails/tree/v0.2.0)

_<sup>released at 2022-06-24 05:14:01 UTC</sup>_

#### Features

- Do not require the `copy-webpack-plugin` to set up Shoelace so the gem works with any js bundler.

## [v0.1.0](https://github.com/yuki24/shoelace-rails/tree/v0.1.0)

_<sup>released at 2022-02-17 13:17:09 UTC</sup>_

First release!

