require File.expand_path('../boot', __FILE__)

require 'rails/all'
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Contestapp
  class Application < Rails::Application
  
   # Shopify API connection credentials:
  config.shopify.api_key = '2797f1bc7e2ae87a08fb90f0713f1712'
    config.shopify.secret ='756bbb6132cc61ad450e5b1bd2e0f411'
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end
