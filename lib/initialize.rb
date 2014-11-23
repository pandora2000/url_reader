require 'rubygems'
require 'bundler/setup'

require 'active_support/all'
require 'rest_client'

ActiveSupport::Dependencies.autoload_paths << File.expand_path('../../lib', __FILE__)
