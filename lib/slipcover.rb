require 'rest_client'
require 'rest'
require 'database'
require 'document'

module Slipcover
  extend Slipcover::Rest

  def self.host
    @host ||= "http://#{env['domain']}:#{env['port']}"
  end

  def self.url
    host
  end

  def self.database
    env['database']
  end

  def self.config_path= path
    @config_path = path
  end

  def self.config_path
    @config_path ||= "#{Rails.root}/db/couch.yml"
  end

  private
  def self.load
    @load ||= YAML::load(File.read(config_path))
  end

  def self.env
    load[Rails.env]
  end
end

