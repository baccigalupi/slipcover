# TODO: remove dependency on Rails
module Slipcover
  class Config
    attr_accessor :env, :path
    attr_reader   :full_config

    def initialize(path=nil, env=nil)
      @path ||= default_path
      @env  ||= default_env
    end

    def default_path
      "#{Rails.root}/db/couch.yml"
    end

    def default_env
      Rails.env.to_sym
    end

    def reset
      @full_config = nil
    end

    def load
      @full_config ||= Hashie::Mash.new(yamled_contents)
    end

    def yamled_contents
      YAML::load(file_contents)
    end

    def file_contents
      @file_contents ||= File.read(path)
    end

    def config
      load[env]
    end
  end
end