# frozen_string_literal: true

require "faraday"

module Circle
  class Connection
    def initialize(api_key:, base_url:, open_timeout:, read_timeout:, user_agent:)
      @conn = Faraday.new(url: base_url) do |f|
        f.request :json
        f.response :json, content_type: /\bjson$/
        f.request :authorization, "Bearer", api_key
        f.headers["User-Agent"] = user_agent
        f.options.open_timeout = open_timeout
        f.options.timeout = read_timeout
        f.adapter Faraday.default_adapter
      end
    end

    def get(path, params = {})
      handle_response { @conn.get(path, params) }
    end

    def post(path, body = {})
      handle_response { @conn.post(path, body) }
    end

    def put(path, body = {})
      handle_response { @conn.put(path, body) }
    end

    def delete(path, params = {})
      handle_response { @conn.delete(path) { |req| req.params = params } }
    end

    private

    def handle_response
      response = yield
      return Response.new(response) if response.success?

      raise Error.from_response(response)
    rescue Faraday::Error => e
      raise ConnectionError.new(e.message)
    end
  end
end
