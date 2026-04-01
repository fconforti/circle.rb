# frozen_string_literal: true

RSpec.describe Circle::Resources::WalletSets do
  let(:client) { build_client }

  describe "#create" do
    it "creates a wallet set" do
      stub_circle_api(:post, "/developer/walletSets",
                       body: { "data" => { "walletSet" => { "id" => "ws-1", "name" => "Test" } } })

      response = client.wallet_sets.create(name: "Test")
      expect(response.data["walletSet"]["id"]).to eq("ws-1")
    end
  end

  describe "#list" do
    it "lists wallet sets" do
      stub_circle_api(:get, "/walletSets",
                       body: { "data" => { "walletSets" => [{ "id" => "ws-1" }] } })

      response = client.wallet_sets.list
      expect(response.data["walletSets"]).to be_an(Array)
    end
  end

  describe "#get" do
    it "retrieves a wallet set" do
      stub_circle_api(:get, "/walletSets/ws-1",
                       body: { "data" => { "walletSet" => { "id" => "ws-1" } } })

      response = client.wallet_sets.get("ws-1")
      expect(response.data["walletSet"]["id"]).to eq("ws-1")
    end
  end

  describe "#update" do
    it "updates a wallet set" do
      stub_circle_api(:put, "/walletSets/ws-1",
                       body: { "data" => { "walletSet" => { "id" => "ws-1", "name" => "New" } } })

      response = client.wallet_sets.update("ws-1", name: "New")
      expect(response.data["walletSet"]["name"]).to eq("New")
    end
  end
end
