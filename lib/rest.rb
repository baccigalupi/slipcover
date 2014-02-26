module Slipcover
  module Rest
    def get path=nil
      RestAdapter.new(url, path).get
    end

    def delete path=nil
      RestAdapter.new(url, path).delete
    end

    def post path=nil, data={}
      RestAdapter.new(url, path, data).post
    end

    def put path=nil, data={}
      RestAdapter.new(url, path, data).put
    end
  end
end

