# frozen_string_literal: true

require "openssl"
require "base64"

module Circle
  class EntitySecret
    def self.encrypt(entity_secret_hex:, public_key_pem:)
      entity_secret_bytes = [entity_secret_hex].pack("H*")
      rsa_key = OpenSSL::PKey::RSA.new(Base64.decode64(public_key_pem))
      encrypted = rsa_key.public_encrypt(entity_secret_bytes, OpenSSL::PKey::RSA::PKCS1_OAEP_PADDING)
      Base64.strict_encode64(encrypted)
    end

    def self.generate
      SecureRandom.hex(32)
    end
  end
end
