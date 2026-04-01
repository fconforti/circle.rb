# frozen_string_literal: true

require "openssl"
require "base64"

RSpec.describe Circle::Webhook do
  let(:ec_key) { OpenSSL::PKey::EC.generate("prime256v1") }
  let(:public_key_b64) { Base64.strict_encode64(ec_key.to_der) }
  let(:payload) { '{"type":"wallet.created","id":"evt-123"}' }

  describe ".verify!" do
    it "returns true for a valid signature" do
      signature = ec_key.sign("SHA256", payload)
      signature_b64 = Base64.strict_encode64(signature)

      result = Circle::Webhook.verify!(
        payload: payload,
        signature_b64: signature_b64,
        public_key_b64: public_key_b64
      )
      expect(result).to be true
    end

    it "returns false for an invalid signature" do
      signature_b64 = Base64.strict_encode64("invalid-signature")

      result = Circle::Webhook.verify!(
        payload: payload,
        signature_b64: signature_b64,
        public_key_b64: public_key_b64
      )
      expect(result).to be false
    end
  end

  describe ".construct_event" do
    it "returns parsed JSON for valid signature" do
      signature = ec_key.sign("SHA256", payload)
      signature_b64 = Base64.strict_encode64(signature)

      event = Circle::Webhook.construct_event(
        payload: payload,
        signature: signature_b64,
        public_key: public_key_b64
      )
      expect(event["type"]).to eq("wallet.created")
      expect(event["id"]).to eq("evt-123")
    end

    it "raises WebhookSignatureError for invalid signature" do
      expect do
        Circle::Webhook.construct_event(
          payload: payload,
          signature: Base64.strict_encode64("bad"),
          public_key: public_key_b64
        )
      end.to raise_error(Circle::WebhookSignatureError, "Invalid webhook signature")
    end
  end
end
