# frozen_string_literal: true

RSpec.describe Circle::Resources::Wallets do
  let(:client) { build_client }

  describe "#create" do
    it "creates wallets" do
      stub_circle_api(:post, "/developer/wallets",
                       body: { "data" => { "wallets" => [{ "id" => "w-1", "address" => "0xabc" }] } })

      response = client.wallets.create(
        wallet_set_id: "ws-1",
        blockchains: ["ETH-SEPOLIA"],
        count: 1
      )
      expect(response.data["wallets"].first["id"]).to eq("w-1")
    end
  end

  describe "#list" do
    it "lists wallets" do
      stub_circle_api(:get, "/wallets",
                       body: { "data" => { "wallets" => [] } })

      response = client.wallets.list
      expect(response.data["wallets"]).to eq([])
    end
  end

  describe "#get" do
    it "retrieves a wallet" do
      stub_circle_api(:get, "/wallets/w-1",
                       body: { "data" => { "wallet" => { "id" => "w-1" } } })

      response = client.wallets.get("w-1")
      expect(response.data["wallet"]["id"]).to eq("w-1")
    end
  end

  describe "#get_token_balance" do
    it "retrieves token balances" do
      stub_circle_api(:get, "/wallets/w-1/balances",
                       body: { "data" => { "tokenBalances" => [{ "amount" => "1.5" }] } })

      response = client.wallets.get_token_balance("w-1")
      expect(response.data["tokenBalances"].first["amount"]).to eq("1.5")
    end
  end
end
