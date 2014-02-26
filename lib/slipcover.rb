require 'rest_client'
require 'hashie/mash'
require 'json'

require 'rest_adapter'
require 'rest'
require 'server'
require 'database'
require 'document_base'
require 'design_document'
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

  def self.parse string
    JSON.parse(string)
  end

  private
    def self.load
      @load ||= Hashie::Mash.new(YAML::load(File.read(config_path)))
    end

    def self.config_env
      load[env]
    end
end

