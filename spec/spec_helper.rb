# frozen_string_literal: true

require "circle"
require "webmock/rspec"

WebMock.disable_net_connect!

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.order = :random

  config.before do
    Circle.reset_configuration!
  end
end

def stub_circle_api(method, path, status: 200, body: {}, request_body: nil)
  url = "https://api.circle.com/v1/w3s#{path}"
  stub = stub_request(method, url)
  stub = stub.with(body: request_body) if request_body
  stub.to_return(
    status: status,
    body: JSON.generate(body),
    headers: { "Content-Type" => "application/json" }
  )
end

def build_client(api_key: "test-api-key", entity_secret: nil)
  Circle::Client.new(api_key: api_key, entity_secret: entity_secret)
end
