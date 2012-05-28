module Slipcover
  class Database
    include Slipcover::Rest
    attr_accessor :name

    def initialize name
      self.name = name
    end

    def url
      "#{Slipcover.url}/#{name}"
    end

    def destroy
      Slipcover.delete name
    end

    def self.create name
      begin
        Slipcover.put(name)
      rescue Exception => e
        raise(e) unless e.message.match /412/i
      end
      new name
    end

    def self.default
      @default ||= create(Slipcover.database)
    end
  end
end

