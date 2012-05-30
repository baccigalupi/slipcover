module Slipcover
  class Document
    include Slipcover::Rest

    attr_accessor :database, :server, :id, :rev, :data

    def initialize data={}, opts={}
      self.id = self.class.uuid
      self.database = opts[:database] || self.class.database
      self.server = database.server
      self.data = Hashie::Mash.new(data)
    end

    def url
      @url ||= "#{database.url}/#{id}"
    end

    def save
      identifiers = {:_id => id}
      identifiers[:_rev] = rev if rev
      response = put(nil, data.merge(identifiers))
      self.rev = response.rev
      self
    end

    def reload
      return self unless rev
      response = get
      self.data = response
      self.rev = response.rev
    end

    def destroy
      return nil unless rev
      response = delete(nil, {:_id => id, :_rev => rev})
    end

    def self.database
      @database ||= Slipcover::Database.default
    end

    def self.database= d
      @database = d
    end

    def self.uuids
      @uuids ||= []
    end

    def self.uuid
      if self.uuids.empty?
        @uuids += Slipcover::Server.default.get('_uuids?count=100')['uuids']
      end
      uuids.pop
    end
  end
end
