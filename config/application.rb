# frozen_string_literal: true

require_relative "boot"

require "rails/all"
require "awesome_print"
require "dot_properties"
require "./lib/alma/config_utils"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Tulcob
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Configuration for the application, engines, and railties goes here.
    config.library_link = "https://library.temple.edu/"
    config.ask_link = "https://library.temple.edu/contact-us"
    config.process_types = config_for(:process_types).with_indifferent_access
    config.libraries = CobIndex::DotProperties.load("libraries_map")
    cob_index_path = Gem::Specification.find_by_name("cob_index").gem_dir
    config.locations = YAML.load_file(cob_index_path + "/lib/translation_maps/locations.yaml").with_indifferent_access
    config.material_types = config_for(:material_types).with_indifferent_access
    config.alma = config_for(:alma).with_indifferent_access
    config.bento = config_for(:bento).with_indifferent_access
    config.email_groups = config_for(:email_groups).with_indifferent_access
    config.oclc = config_for(:oclc).with_indifferent_access
    config.lib_guides = config_for(:lib_guides).with_indifferent_access
    config.devise = config_for(:devise).with_indifferent_access
    config.caches = config_for(:caches).with_indifferent_access
    config.features = Hash.new.with_indifferent_access
    config.quik_pay = config_for(:quik_pay).with_indifferent_access
    config.exceptions_app = routes
    config.time_zone = "Eastern Time (US & Canada)"
    config.active_record.default_timezone = :local


    config.generators do |g|
      g.test_framework :rspec, spec: true
      g.fixture_replacement :factory_bot
    end
    #config.log_level = :debug
  end
end

Honeybadger.configure do |config|
  secrets = {
    solrcloud_user: ENV["SOLRCLOUD_USER"],
    solrcloud_password: ENV["SOLRCLOUD_PASSWORD"],
    primo_apikey: Rails.configuration.bento.dig("primo", "apikey"),
    alma_apikey: Rails.configuration.alma["apikey"],
  }

  config.before_notify do |notice|
    secrets.each do |secret_name, secret_value|
      notice.error_message.gsub!(secret_value, "[:#{secret_name}]") unless secret_value.blank?
    end

    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
