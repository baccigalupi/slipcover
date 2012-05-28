require 'rest_client'
require 'hashie/mash'

require 'rest'
require 'server'
require 'database'
require 'document'

module Slipcover
  def self.env= e
    @env ||= e.to_sym
  end

  def self.env
    @env ||= Rails.env.to_sym
  end

  def self.database
    config_env[:database]
  end

  def self.config_path= path
    @config_path = path
  end

  def self.config_path
    @config_path ||= "#{Rails.root}/db/couch.yml"
  end

  private
    def self.load
      @load ||= Hashie::Mash.new(YAML::load(File.read(config_path)))
    end

    def self.config_env
      load[env]
    end
end

