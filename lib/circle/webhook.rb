# frozen_string_literal: true

require "openssl"
require "base64"
require "json"

module Circle
  class Webhook
    def self.verify!(payload:, signature_b64:, public_key_b64:)
      public_key_der = Base64.decode64(public_key_b64)
      key = OpenSSL::PKey.read(public_key_der)
      signature_bytes = Base64.decode64(signature_b64)
      key.verify("SHA256", signature_bytes, payload)
    rescue OpenSSL::PKey::PKeyError
      false
    end

    def self.construct_event(payload:, signature:, public_key:)
      verified = verify!(payload: payload, signature_b64: signature, public_key_b64: public_key)
      raise WebhookSignatureError, "Invalid webhook signature" unless verified

      JSON.parse(payload)
    end
  end
end
