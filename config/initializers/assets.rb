# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.precompile += %w( bootstrap.min.css )
Rails.application.config.assets.precompile += %w( style.css )
Rails.application.config.assets.precompile += %w( jquery.min.js )
Rails.application.config.assets.precompile += %w( jquery.validate.js )
Rails.application.config.assets.precompile += %w( additional-methods.js )
Rails.application.config.assets.precompile += %w( bootstrap.min.js )
Rails.application.config.assets.precompile += %w( custom.js )
Rails.application.config.assets.precompile += %w( ckeditor/* )
Rails.application.config.assets.precompile += %w( calculator.scss )
Rails.application.config.assets.precompile += %w( highcharts )
Rails.application.config.assets.precompile += %w( chartkick.js )
Rails.application.config.assets.precompile += %w( Chart.bundle )
Rails.application.config.assets.precompile += %w( maskmoney )
Rails.application.config.assets.precompile += %w( scrollBar.css )
Rails.application.config.assets.precompile += %w( scrollBar.js )
Rails.application.config.assets.precompile += %w( highchart.js )
Rails.application.config.assets.precompile += %w( programsearch.js )
Rails.application.config.assets.precompile += %w( owl.carousel.min.js )
Rails.application.config.assets.precompile += %w( owl.carousel.min.css )
Rails.application.config.assets.precompile += %w( slider.css )


# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
