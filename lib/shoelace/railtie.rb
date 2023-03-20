# frozen_string_literal: true

require 'action_dispatch/middleware/static'

module Shoelace
  mattr_accessor :invalid_input_class_name
  self.invalid_input_class_name = nil

  # The only reason this class exists is to clarify that we have a custom static file server after
  # `ActionDispatch::Static`. We could just use `ActionDispatch::Static` directly, but it would make the result of
  # `rake middleware` more difficult to understand, as the output would look like:
  #
  #    use ...
  #    use ActionDispatch::Static
  #    use ActionDispatch::Static # Why do we use the same middleware twice?
  #    use ...
  #
  # It is much more straightforward if it looks like:
  #
  #    use ...
  #    use ActionDispatch::Static
  #    use Shoelace::AssetProvider
  #    use ...
  #
  class AssetProvider < ActionDispatch::Static; end

  class Railtie < ::Rails::Railtie #:nodoc:
    config.shoelace = ActiveSupport::OrderedOptions.new

    # Path to the shoelace assets.
    config.shoelace.dist_path = "node_modules/@shoelace-style/shoelace/dist"

    # Class name that is added to a form input when the corresponding attribute has an `ActiveModel` error.
    config.shoelace.invalid_input_class_name = nil

    initializer "shoelace.use_rack_middleware" do |app|
      icon_dir = File.join(app.paths["public"].first, "assets/icons")

      if !Dir.exist?(icon_dir)
        path    = app.root.join(app.config.shoelace.dist_path).to_s
        headers = app.config.public_file_server.headers || {}

        app.config.middleware.insert_after ActionDispatch::Static, Shoelace::AssetProvider, path, index: "index.html", headers: headers
      end
    end

    initializer "shoelace.form_helper" do |app|
      ActiveSupport.on_load :action_view do
        Shoelace.invalid_input_class_name = app.config.shoelace.invalid_input_class_name
      end
    end

    rake_tasks do
      load "tasks/shoelace.rake"
    end
  end
end
