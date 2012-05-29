module Slipcover
  module Rest
    def get path=nil
      _parse_response( RestClient.get _pathify(path) )
    end

    def delete path=nil
      _parse_response( RestClient.delete _pathify(path) )
    end

    def post path=nil, data={}
      _parse_response( RestClient.post _pathify(path), data.to_json )
    end

    def put path=nil, data={}
      _parse_response( RestClient.put _pathify(path), data.to_json )
    end

    private
      def _pathify path
        "#{url}#{path ? "/" + path : ''}"
      end

      def _parse_response response
        begin
          response = JSON.parse(response)
          response.is_a?(Hash) ? Hashie::Mash.new(response) : response
        rescue
          response
        end
      end
  end
end

