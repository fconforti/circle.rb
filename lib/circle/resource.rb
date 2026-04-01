# frozen_string_literal: true

require "securerandom"

module Circle
  class Resource
    API_PATH = "/v1/w3s"

    attr_reader :client

    def initialize(client)
      @client = client
    end

    private

    def get_request(path, params = {})
      client.connection.get("#{API_PATH}#{path}", Util.deep_snake_to_camel(params))
    end

    def post_request(path, body = {}, inject_entity_secret: false)
      body = Util.deep_snake_to_camel(body)
      body["idempotencyKey"] ||= SecureRandom.uuid
      if inject_entity_secret && client.entity_secret
        body["entitySecretCiphertext"] = client.generate_entity_secret_ciphertext
      end
      client.connection.post("#{API_PATH}#{path}", body)
    end

    def put_request(path, body = {})
      client.connection.put("#{API_PATH}#{path}", Util.deep_snake_to_camel(body))
    end

    def delete_request(path, body = {})
      client.connection.delete("#{API_PATH}#{path}", Util.deep_snake_to_camel(body))
    end
  end
end
