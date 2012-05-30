module Slipcover
  class Document < DocumentBase
    attr_accessor :id

    def initialize data={}, opts={}
      self.id = self.class.uuid
      super(opts)
      self.data = Hashie::Mash.new(data)
    end

    def [](key)
      data[key]
    end

    def []=(key, value)
      data[key] = value
    end

    def self.queries views={}
      @queries ||= Slipcover::DesignDocument.create(self.to_s, database, views)
    end
  end
end
