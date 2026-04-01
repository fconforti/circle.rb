# frozen_string_literal: true

RSpec.describe Circle::Resources::Contracts do
  let(:client) { build_client }

  describe "#deploy" do
    it "deploys a contract" do
      stub_circle_api(:post, "/contracts/deploy",
                       body: { "data" => { "contractId" => "c-1", "transactionId" => "tx-1" } })

      response = client.contracts.deploy(
        abi_json: "[]",
        blockchain: "ETH-SEPOLIA",
        bytecode: "0x...",
        name: "MyToken",
        wallet_id: "w-1",
        fee_level: "MEDIUM"
      )
      expect(response.data["contractId"]).to eq("c-1")
    end
  end

  describe "#list" do
    it "lists contracts" do
      stub_circle_api(:get, "/contracts",
                       body: { "data" => { "contracts" => [{ "id" => "c-1" }] } })

      response = client.contracts.list
      expect(response.data["contracts"]).to be_an(Array)
    end
  end

  describe "#get" do
    it "retrieves a contract" do
      stub_circle_api(:get, "/contracts/c-1",
                       body: { "data" => { "contract" => { "id" => "c-1", "name" => "MyToken" } } })

      response = client.contracts.get("c-1")
      expect(response.data["contract"]["name"]).to eq("MyToken")
    end
  end

  describe "#query" do
    it "queries contract state" do
      stub_circle_api(:post, "/contracts/query",
                       body: { "data" => { "outputValues" => ["100"] } })

      response = client.contracts.query(
        address: "0xcontract",
        blockchain: "ETH-SEPOLIA",
        abi_function_signature: "balanceOf(address)",
        abi_parameters: ["0xowner"]
      )
      expect(response.data["outputValues"]).to eq(["100"])
    end
  end
end
