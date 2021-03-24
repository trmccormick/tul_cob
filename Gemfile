# frozen_string_literal: true

source "https://rubygems.org"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 5.2"
# Use Puma as the app server
gem "puma", "~> 5.2"
gem "popper_js"
gem "twitter-typeahead-rails", "0.11.1"
# Use SCSS for stylesheets
gem "sass-rails", "~> 6.0"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"
# Use CoffeeScript for .coffee assets and views
gem "coffee-rails", "~> 5.0"
gem "autoprefixer-rails"
gem "execjs"
gem "bootstrap-select-rails"
gem "bootstrap", "~> 4.6"

# Use jquery as the JavaScript library
gem "jquery-rails"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.11"


group :development do
  gem "flamegraph"
  gem "listen", "~> 3.5.0"
  gem "ruby-prof"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "stackprof"
  gem "web-console"
  gem "sqlite3"
end

# windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem "blacklight", "~> 7.15.2"
gem "blacklight_advanced_search", git: "https://github.com/projectblacklight/blacklight_advanced_search.git"
gem "blacklight-marc"
gem "blacklight_range_limit"

group :development, :test do
  gem "byebug", platform: :mri
  gem "pry-rails"
  gem "coveralls"
  gem "solr_wrapper", ">= 0.3"
  gem "rspec-rails"
  gem "database_cleaner"
  gem "factory_bot_rails"
  gem "simplecov", require: false
  gem "guard-rspec", require: false
  gem "guard-shell"
  gem "launchy"
  gem "foreman"
  gem "vcr"
  gem "rack-mini-profiler", require: false
  gem "rails-controller-testing"
  gem "rubocop"
  gem "rubocop-rails"
  gem "cob_web_index", git: "https://github.com/tulibraries/cob_web_index.git",
    branch: "main"

  gem "cob_az_index", git: "https://github.com/tulibraries/cob_az_index.git",
    branch: "main"

  gem "capybara", "3.35.3"
  gem "webmock"
end

gem "cob_index",
  git: "https://github.com/tulibraries/cob_index.git",
  branch: "main"

gem "rsolr", "~> 2.3"
gem "devise"
gem "devise-guests", "~> 0.7"
gem "alma", git: "https://github.com/tulibraries/alma_rb.git", branch: "main"
gem "cdm", git: "https://github.com/tulibraries/cdm_rb.git", branch: "master"
gem "lc_solr_sortable", git: "https://github.com/tulibraries/lc_solr_sortable", branch: "main"
# 1/31/17 - Hashie 3.5.0 breaks omniauth, so peg to previous
gem "hashie", "~>3.6.0"
gem "omniauth"
gem "blacklight_alma", git: "https://github.com/tulibraries/blacklight_alma.git", branch: "update-blacklight"
gem "ezwadl"
gem "awesome_print"
gem "bento_search"
gem "omniauth-shibboleth"
gem "skylight"
gem "webpacker", "6.0.0.pre.2"
gem "google-analytics-rails", "1.1.1"
gem "primo", git: "https://github.com/tulibraries/primo", branch: "main"
gem "bootsnap"
gem "honeybadger", "4.8.0"
gem "browser"
gem "blacklight-ris", git: "https://github.com/upenn-libraries/blacklight-ris.git"
gem "httparty"
gem "dotenv-rails"

group :production do
  gem "mysql2", "~> 0.5.3"
  # required for using memcached
  gem "dalli"
end

# devops
gem "okcomputer"
