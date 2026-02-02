require "zeitwerk"
loader = Zeitwerk::Loader.for_gem(warn_on_extra_files: false)
loader.inflector.inflect("giki-config" => "GikiConfig")
loader.inflector.inflect("version" => "VERSION")
loader.setup

require 'aws-sdk-dynamodb'
require 'aws-sdk-secretsmanager'
require 'mandate'
require 'ostruct'
require 'json'

module ::GikiConfig
end
