require 'rest_client'
require 'hashie/mash'
require 'json'

require 'rest_adapter'
require 'rest'
require 'config'
require 'server'
require 'database'
require 'document_base'
require 'design_document'
require 'document'

module Slipcover
  def self.default_config
    @default_config ||= Config.new
  end

  def self.config
    default_config.config
  end
end

