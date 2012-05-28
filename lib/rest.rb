module Slipcover
  module Rest
    def get path
      RestClient.get "#{url}/#{path}"
    end

    def delete path
      RestClient.delete "#{url}/#{path}"
    end

    def post path, data={}
      RestClient.post "#{url}/#{path}", data
    end

    def put path, data={}
      RestClient.put "#{url}/#{path}", data
    end
  end
end

