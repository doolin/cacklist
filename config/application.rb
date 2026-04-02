require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Cacklist
  class Application < Rails::Application
    config.load_defaults 7.2

    config.encoding = 'utf-8'

    config.filter_parameters += %i[password password_confirmation]

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
