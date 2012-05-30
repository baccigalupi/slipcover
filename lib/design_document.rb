module Slipcover
  class DesignDocument < DocumentBase
    attr_accessor :name, :views

    def initialize name, database, views={}
      self.name = name
      super({:database => database})
      self.views = Hashie::Mash.new(views)
    end

    def id
      "_design/#{name}"
    end

    def data
      Hashie::Mash.new(:views => views)
    end

    def [](key)
      views[key]
    end

    def []=(key, value)
      views[key] = value
    end
  end
end
