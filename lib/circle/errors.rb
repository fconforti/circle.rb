# frozen_string_literal: true

module Circle
  class Error < StandardError
    attr_reader :http_status, :error_code, :raw_response

    def initialize(message = nil, http_status: nil, error_code: nil, raw_response: nil)
      @http_status = http_status
      @error_code = error_code
      @raw_response = raw_response
      super(message)
    end

    def self.from_response(response)
      body = response.body
      message = body.is_a?(Hash) ? body["message"] : body.to_s
      error_code = body.is_a?(Hash) ? body["code"] : nil

      klass = case response.status
              when 400 then ValidationError
              when 401 then AuthenticationError
              when 403 then ForbiddenError
              when 404 then NotFoundError
              when 409 then ConflictError
              when 429 then RateLimitError
              when 500..599 then ServerError
              else Error
              end

      klass.new(message, http_status: response.status, error_code: error_code, raw_response: body)
    end
  end

  class AuthenticationError < Error; end
  class ForbiddenError < Error; end
  class NotFoundError < Error; end
  class ValidationError < Error; end
  class ConflictError < Error; end
  class RateLimitError < Error; end
  class ServerError < Error; end
  class ConnectionError < Error; end
  class WebhookSignatureError < Error; end
end
