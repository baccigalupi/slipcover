module Slipcover
  class DocumentBase
    include Slipcover::Rest

    attr_accessor :database, :rev, :data

    def initialize opts={}
      self.database = opts[:database] || self.class.database
    end

    def url
      @url ||= "#{database.url}/#{id}"
    end


    def save
      response = put(nil, data.merge(data_identifiers))
      self.rev = response.rev
      self
    end

    def data_identifiers
      identifiers = {:_id => id}
      identifiers[:_rev] = rev if rev
      identifiers
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
    
    def self.get id
      data = database.get(id)
      doc = new data
      doc.id = id
      doc.rev = data[:_rev]
      doc
    end

    def self.create *args
      doc = new *args
      doc.save
    end
  end
end
