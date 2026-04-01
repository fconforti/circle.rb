# frozen_string_literal: true

require "openssl"
require "base64"

module Circle
  class EntitySecret
    def self.encrypt(entity_secret_hex:, public_key_pem:)
      entity_secret_bytes = [entity_secret_hex].pack("H*")
      rsa_key = OpenSSL::PKey::RSA.new(public_key_pem)
      encrypted = rsa_key.encrypt(
        entity_secret_bytes,
        {
          "rsa_padding_mode" => "oaep",
          "rsa_oaep_md" => "sha256",
          "rsa_mgf1_md" => "sha256"
        }
      )
      Base64.strict_encode64(encrypted)
    end

    def self.generate
      SecureRandom.hex(32)
    end
  end
end
