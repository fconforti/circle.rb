# frozen_string_literal: true

RSpec.describe Circle::Resources::Signing do
  let(:client) { build_client }

  describe "#sign_message" do
    it "signs a message" do
      stub_circle_api(:post, "/developer/sign/message",
                       body: { "data" => { "signature" => "0xabc123" } })

      response = client.signing.sign_message(wallet_id: "w-1", message: "hello")
      expect(response.data["signature"]).to eq("0xabc123")
    end
  end

  describe "#sign_typed_data" do
    it "signs typed data" do
      stub_circle_api(:post, "/developer/sign/typedData",
                       body: { "data" => { "signature" => "0xdef456" } })

      response = client.signing.sign_typed_data(wallet_id: "w-1", data: "{}")
      expect(response.data["signature"]).to eq("0xdef456")
    end
  end

  describe "#sign_transaction" do
    it "signs a transaction" do
      stub_circle_api(:post, "/developer/sign/transaction",
                       body: { "data" => { "signature" => "0x789", "signedTransaction" => "0xsigned" } })

      response = client.signing.sign_transaction(wallet_id: "w-1", raw_transaction: "0xraw")
      expect(response.data["signedTransaction"]).to eq("0xsigned")
    end
  end
end
