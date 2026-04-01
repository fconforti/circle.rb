# frozen_string_literal: true

RSpec.describe Circle::Connection do
  let(:client) { build_client }

  describe "#get" do
    it "makes a GET request and returns a Response" do
      stub_circle_api(:get, "/wallets", body: { "data" => { "wallets" => [] } })

      response = client.connection.get("/v1/w3s/wallets")
      expect(response).to be_a(Circle::Response)
      expect(response.data).to eq({ "wallets" => [] })
    end

    it "raises NotFoundError on 404" do
      stub_circle_api(:get, "/wallets/bad-id", status: 404, body: { "message" => "Not found" })

      expect { client.connection.get("/v1/w3s/wallets/bad-id") }
        .to raise_error(Circle::NotFoundError, "Not found")
    end
  end

  describe "#post" do
    it "makes a POST request with JSON body" do
      stub_circle_api(:post, "/developer/walletSets",
                       body: { "data" => { "walletSet" => { "id" => "ws-1" } } })

      response = client.connection.post("/v1/w3s/developer/walletSets", { name: "Test" })
      expect(response.data).to eq({ "walletSet" => { "id" => "ws-1" } })
    end
  end

  describe "#put" do
    it "makes a PUT request" do
      stub_circle_api(:put, "/walletSets/ws-1",
                       body: { "data" => { "walletSet" => { "id" => "ws-1" } } })

      response = client.connection.put("/v1/w3s/walletSets/ws-1", { name: "Updated" })
      expect(response.status).to eq(200)
    end
  end

  describe "#delete" do
    it "makes a DELETE request" do
      stub_circle_api(:delete, "/subscriptions/sub-1", body: {})

      response = client.connection.delete("/v1/w3s/subscriptions/sub-1")
      expect(response.status).to eq(200)
    end
  end
end
