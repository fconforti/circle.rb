# frozen_string_literal: true

RSpec.describe Circle::Resources::Users do
  let(:client) { build_client }

  describe "#create" do
    it "creates a user" do
      stub_circle_api(:post, "/users",
                       body: { "data" => { "user" => { "id" => "u-1", "status" => "ENABLED" } } })

      response = client.users.create(user_id: "ext-user-1")
      expect(response.data["user"]["id"]).to eq("u-1")
    end
  end

  describe "#list" do
    it "lists users" do
      stub_circle_api(:get, "/users",
                       body: { "data" => { "users" => [{ "id" => "u-1" }] } })

      response = client.users.list
      expect(response.data["users"]).to be_an(Array)
    end
  end

  describe "#get" do
    it "retrieves a user" do
      stub_circle_api(:get, "/users/u-1",
                       body: { "data" => { "user" => { "id" => "u-1", "status" => "ENABLED" } } })

      response = client.users.get("u-1")
      expect(response.data["user"]["status"]).to eq("ENABLED")
    end
  end

  describe "#create_token" do
    it "creates a user token" do
      stub_circle_api(:post, "/users/token",
                       body: { "data" => { "userToken" => "jwt-token", "encryptionKey" => "enc-key" } })

      response = client.users.create_token(user_id: "ext-user-1")
      expect(response.data["userToken"]).to eq("jwt-token")
    end
  end
end
