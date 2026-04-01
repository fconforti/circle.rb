# frozen_string_literal: true

module Circle
  class Response
    attr_reader :data, :status, :raw_body

    def initialize(faraday_response)
      @status = faraday_response.status
      @raw_body = faraday_response.body
      @data = extract_data(@raw_body)
    end

    private

    def extract_data(body)
      return body unless body.is_a?(Hash)

      body.key?("data") ? body["data"] : body
    end
  end
end
