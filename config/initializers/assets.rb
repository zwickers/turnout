# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( bootstrap/css/bootstrap.css )
Rails.application.config.assets.precompile += %w( fontawesome-free/css/all.min.css )
Rails.application.config.assets.precompile += %w( simple-line-icons/css/simple-line-icons.css )
Rails.application.config.assets.precompile += %w( jquery/jquery.min.js )
Rails.application.config.assets.precompile += %w( bootstrap/js/bootstrap.bundle.min.js )
Rails.application.config.assets.precompile += %w( jquery-easing/jquery.easing.min.js )
Rails.application.config.assets.precompile += %w( device-mockups/device-mockups.min.css )
Rails.application.config.assets.precompile += %w( homepage.css )
Rails.application.config.assets.precompile += %w( homepage.js )