module Slipcover
  class Server
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
      return @url if @url
      user_string = user ? "#{user}:#{password}@" : ''
      port_string = port ? ":#{port}" : ''
      @url = "#{protocol}://#{user_string}#{domain}#{port_string}"
    end

    def self.default
      @default ||= new(Slipcover.config_env)
    end

    def self.default= d
      server = new
      server.url = d
      @default = server
    end
  end
end
