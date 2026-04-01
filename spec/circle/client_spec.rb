# frozen_string_literal: true

RSpec.describe Circle::Client do
  describe "#initialize" do
    it "requires an api_key" do
      expect { Circle::Client.new }.to raise_error(ArgumentError, "api_key is required")
    end

    it "accepts api_key directly" do
      client = Circle::Client.new(api_key: "test-key")
      expect(client.api_key).to eq("test-key")
    end

    it "falls back to global configuration" do
      Circle.configure { |c| c.api_key = "global-key" }
      client = Circle::Client.new
      expect(client.api_key).to eq("global-key")
    end

    it "stores entity_secret" do
      client = Circle::Client.new(api_key: "key", entity_secret: "abc123")
      expect(client.entity_secret).to eq("abc123")
    end
  end

  describe "resource accessors" do
    let(:client) { build_client }

    it "returns WalletSets resource" do
      expect(client.wallet_sets).to be_a(Circle::Resources::WalletSets)
    end

    it "returns Wallets resource" do
      expect(client.wallets).to be_a(Circle::Resources::Wallets)
    end

    it "returns Transactions resource" do
      expect(client.transactions).to be_a(Circle::Resources::Transactions)
    end

    it "returns Signing resource" do
      expect(client.signing).to be_a(Circle::Resources::Signing)
    end

    it "returns Users resource" do
      expect(client.users).to be_a(Circle::Resources::Users)
    end

    it "returns Contracts resource" do
      expect(client.contracts).to be_a(Circle::Resources::Contracts)
    end

    it "memoizes resource instances" do
      expect(client.wallets).to be(client.wallets)
    end
  end
end
