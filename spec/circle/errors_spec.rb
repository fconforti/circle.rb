# frozen_string_literal: true

RSpec.describe Circle::Error do
  describe ".from_response" do
    def fake_response(status:, body:)
      double("response", status: status, body: body, success?: false)
    end

    it "maps 400 to ValidationError" do
      resp = fake_response(status: 400, body: { "code" => 1, "message" => "Invalid param" })
      error = Circle::Error.from_response(resp)
      expect(error).to be_a(Circle::ValidationError)
      expect(error.message).to eq("Invalid param")
      expect(error.error_code).to eq(1)
      expect(error.http_status).to eq(400)
    end

    it "maps 401 to AuthenticationError" do
      resp = fake_response(status: 401, body: { "message" => "Unauthorized" })
      error = Circle::Error.from_response(resp)
      expect(error).to be_a(Circle::AuthenticationError)
    end

    it "maps 403 to ForbiddenError" do
      resp = fake_response(status: 403, body: { "message" => "Forbidden" })
      expect(Circle::Error.from_response(resp)).to be_a(Circle::ForbiddenError)
    end

    it "maps 404 to NotFoundError" do
      resp = fake_response(status: 404, body: { "message" => "Not found" })
      expect(Circle::Error.from_response(resp)).to be_a(Circle::NotFoundError)
    end

    it "maps 409 to ConflictError" do
      resp = fake_response(status: 409, body: { "message" => "Conflict" })
      expect(Circle::Error.from_response(resp)).to be_a(Circle::ConflictError)
    end

    it "maps 429 to RateLimitError" do
      resp = fake_response(status: 429, body: { "message" => "Rate limited" })
      expect(Circle::Error.from_response(resp)).to be_a(Circle::RateLimitError)
    end

    it "maps 500 to ServerError" do
      resp = fake_response(status: 500, body: { "message" => "Internal error" })
      expect(Circle::Error.from_response(resp)).to be_a(Circle::ServerError)
    end

    it "maps 502 to ServerError" do
      resp = fake_response(status: 502, body: { "message" => "Bad gateway" })
      expect(Circle::Error.from_response(resp)).to be_a(Circle::ServerError)
    end
  end
end
