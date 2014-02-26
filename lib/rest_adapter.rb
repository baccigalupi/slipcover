module Slipcover  
  class RestAdapter
    attr_reader   :url, :path, :data
    attr_accessor :response

    def initialize(url, path, data={})
      @url = url
      @path = path
      @data = data
    end

    def parse(response)
      begin
        response = JSON.parse(response)
        response.is_a?(Hash) ? Hashie::Mash.new(response) : response
      rescue
        response
      end
    end

    def full_path
      "#{url}#{normalized_path}"
    end

    def normalized_path
      path ? "/#{path}" : '' 
    end

    def get
      parse(
        adapter.get(full_path)
      )
    end

    def delete
      parse(
        adapter.delete(full_path)
      )
    end

    def post
      parse(
        adapter.post(full_path, data.to_json)
      )
    end

    def put
      parse(
        adapter.put(full_path, data.to_json)
      )
    end

    def adapter
      RestClient
    end
  end
end