module Slipcover
  class Server
    include Slipcover::Rest

    attr_accessor :protocol, :domain, :port, :user, :password

    def initialize opts={}
      self.protocol = opts[:protocol] || 'http'
      self.domain = opts[:domain] || 'localhost'
      self.port = opts[:port]
      self.user = opts[:user]
      self.password = opts[:password]
    end

    def url= u
      @url = u
    end

    def url
      @url ||= "#{protocol}://#{user_string}#{domain}#{port_string}"
    end

    def user_string
      user ? "#{user}:#{password}@" : ''
    end

    def port_string
      port ? ":#{port}" : ''
    end

    def ==(other)
      url == other.url
    end

    def self.default
      @default ||= new(Slipcover.config)
    end

    def self.default= d
      server = new
      server.url = d
      @default = server
    end
  end
end
