# frozen_string_literal: true

RSpec.describe Circle::Resources::Transactions do
  let(:client) { build_client }

  describe "#create_transfer" do
    it "creates a transfer transaction" do
      stub_circle_api(:post, "/developer/transactions/transfer",
                       body: { "data" => { "id" => "tx-1", "state" => "INITIATED" } })

      response = client.transactions.create_transfer(
        wallet_id: "w-1",
        token_id: "tok-1",
        amounts: ["1.0"],
        destination_address: "0xdef"
      )
      expect(response.data["id"]).to eq("tx-1")
      expect(response.data["state"]).to eq("INITIATED")
    end
  end

  describe "#list" do
    it "lists transactions" do
      stub_circle_api(:get, "/transactions",
                       body: { "data" => { "transactions" => [{ "id" => "tx-1" }] } })

      response = client.transactions.list
      expect(response.data["transactions"]).to be_an(Array)
    end
  end

  describe "#get" do
    it "retrieves a transaction" do
      stub_circle_api(:get, "/transactions/tx-1",
                       body: { "data" => { "transaction" => { "id" => "tx-1", "state" => "COMPLETE" } } })

      response = client.transactions.get("tx-1")
      expect(response.data["transaction"]["state"]).to eq("COMPLETE")
    end
  end

  describe "#estimate_transfer_fee" do
    it "estimates fees" do
      stub_circle_api(:post, "/transactions/transfer/estimateFee",
                       body: { "data" => { "low" => { "networkFee" => "0.001" } } })

      response = client.transactions.estimate_transfer_fee(
        token_id: "tok-1",
        amounts: ["1.0"],
        destination_address: "0xdef"
      )
      expect(response.data["low"]["networkFee"]).to eq("0.001")
    end
  end
end
