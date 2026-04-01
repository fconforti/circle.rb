# frozen_string_literal: true

module Circle
  module Resources
    class Faucet < Resource
      FAUCET_PATH = "/v1/faucet"

      def request_tokens(**params)
        body = Util.deep_snake_to_camel(params)
        body["idempotencyKey"] ||= SecureRandom.uuid
        client.connection.post("#{FAUCET_PATH}/drips", body)
      end
    end
  end
end
