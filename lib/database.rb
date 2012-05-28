module Slipcover
  class Database
    include Slipcover::Rest
    attr_accessor :name, :server

    def initialize name, opts={}
      self.name = name
      self.server = opts[:server] || Slipcover::Server.default
    end

    def url
      "#{server.url}/#{name}"
    end

    def destroy
      server.delete name
    end

    def self.create name, opts={}
      server = opts[:server] || Slipcover::Server.default
      begin
        server.put(name)
      rescue Exception => e
        raise(e) unless e.message.match /412/i
      end
      new name, opts
    end

    def self.default
      @default ||= create(Slipcover.database)
    end
  end
end

