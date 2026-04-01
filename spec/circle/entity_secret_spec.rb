# frozen_string_literal: true

require "openssl"
require "base64"

RSpec.describe Circle::EntitySecret do
  describe ".encrypt" do
    it "encrypts a 32-byte entity secret with RSA-OAEP SHA-256" do
      rsa_key = OpenSSL::PKey::RSA.generate(2048)
      public_key_pem = rsa_key.public_key.to_pem
      entity_secret_hex = "a" * 64 # 32 bytes in hex

      ciphertext_b64 = Circle::EntitySecret.encrypt(
        entity_secret_hex: entity_secret_hex,
        public_key_pem: public_key_pem
      )

      # Verify we can decrypt it
      ciphertext = Base64.decode64(ciphertext_b64)
      decrypted = rsa_key.decrypt(
        ciphertext,
        {
          "rsa_padding_mode" => "oaep",
          "rsa_oaep_md" => "sha256",
          "rsa_mgf1_md" => "sha256"
        }
      )
      expect(decrypted.unpack1("H*")).to eq(entity_secret_hex)
    end

    it "produces unique ciphertext each time (OAEP padding)" do
      rsa_key = OpenSSL::PKey::RSA.generate(2048)
      public_key_pem = rsa_key.public_key.to_pem
      entity_secret_hex = "b" * 64

      ct1 = Circle::EntitySecret.encrypt(entity_secret_hex: entity_secret_hex, public_key_pem: public_key_pem)
      ct2 = Circle::EntitySecret.encrypt(entity_secret_hex: entity_secret_hex, public_key_pem: public_key_pem)

      expect(ct1).not_to eq(ct2)
    end
  end

  describe ".generate" do
    it "returns a 64-character hex string" do
      secret = Circle::EntitySecret.generate
      expect(secret).to match(/\A[0-9a-f]{64}\z/)
    end
  end
end
