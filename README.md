# circle-sdk

Ruby client for [Circle Web3 Services API](https://developers.circle.com/).

## Installation

```ruby
gem "circle-sdk"
```

## Configuration

```ruby
Circle.configure do |config|
  config.api_key = "TEST_API_KEY:..."
  config.entity_secret = "your-64-char-hex-entity-secret" # optional, needed for developer-controlled wallet write ops
end

client = Circle::Client.new
```

Or pass credentials directly:

```ruby
client = Circle::Client.new(api_key: "TEST_API_KEY:...", entity_secret: "...")
```

## Usage

### Developer-Controlled Wallets

```ruby
# Wallet Sets
client.wallet_sets.create(name: "My Wallet Set")
client.wallet_sets.list
client.wallet_sets.get("wallet-set-id")

# Wallets
client.wallets.create(wallet_set_id: "ws-id", blockchains: ["ETH-SEPOLIA"], count: 2)
client.wallets.list(blockchain: "ETH-SEPOLIA")
client.wallets.get("wallet-id")
client.wallets.get_token_balance("wallet-id")
client.wallets.get_nft_balance("wallet-id")

# Transactions
client.transactions.create_transfer(
  wallet_id: "wallet-id",
  token_id: "token-id",
  amounts: ["1.0"],
  destination_address: "0x..."
)
client.transactions.list
client.transactions.get("tx-id")
client.transactions.estimate_transfer_fee(token_id: "tok-id", amounts: ["1.0"], destination_address: "0x...")

# Signing
client.signing.sign_message(wallet_id: "wallet-id", message: "Hello World")
client.signing.sign_typed_data(wallet_id: "wallet-id", data: '{"types":...}')
client.signing.sign_transaction(wallet_id: "wallet-id", raw_transaction: "0x...")
```

### User-Controlled Wallets

```ruby
# Users
client.users.create(user_id: "my-user-id")
client.users.list
response = client.users.create_token(user_id: "my-user-id")
user_token = response.data["userToken"]

# User Wallets
client.user_wallets.create(user_token: user_token, blockchains: ["ETH-SEPOLIA"])
client.user_wallets.list(user_token: user_token)

# User Transactions
client.user_transactions.create_transfer(user_token: user_token, wallet_id: "w-id", token_id: "tok-id", amounts: ["1.0"], destination_address: "0x...")

# User Signing
client.user_signing.sign_message(user_token: user_token, wallet_id: "w-id", message: "Hello")
```

### Smart Contract Platform

```ruby
# Deploy
client.contracts.deploy(
  abi_json: abi_string,
  blockchain: "ETH-SEPOLIA",
  bytecode: "0x...",
  name: "MyToken",
  wallet_id: "wallet-id",
  fee_level: "MEDIUM"
)

# Import existing contract
client.contracts.import(address: "0x...", blockchain: "ETH-SEPOLIA", name: "USDC")

# Query contract state
client.contracts.query(
  address: "0x...",
  blockchain: "ETH-SEPOLIA",
  abi_function_signature: "balanceOf(address)",
  abi_parameters: ["0xowner"]
)

# Event Monitors
client.event_monitors.create(blockchain: "ETH-SEPOLIA", contract_address: "0x...", event_signature: "Transfer(address,address,uint256)")
client.event_logs.list(blockchain: "ETH-SEPOLIA")
```

### Webhook Verification

```ruby
event = Circle::Webhook.construct_event(
  payload: request.body.read,
  signature: request.headers["X-Circle-Signature"],
  public_key: public_key_b64  # fetched via client.subscriptions.get_notification_signature(sub_id)
)
```

### Other Resources

```ruby
# Tokens
client.tokens.get("token-id")

# Monitored Tokens
client.monitored_tokens.create(token_ids: ["tok-1", "tok-2"])
client.monitored_tokens.list

# Subscriptions (Webhooks)
client.subscriptions.create(endpoint: "https://example.com/webhooks")
client.subscriptions.list

# Faucet (testnet only)
client.faucet.request_tokens(address: "0x...", blockchain: "ETH-SEPOLIA", usdc: true)

# Address Validation
client.address_validation.validate(address: "0x...", blockchain: "ETH")
```

## Response Format

All methods return a `Circle::Response` with:
- `response.data` — the unwrapped response data (Circle wraps responses in `{"data": ...}`)
- `response.status` — HTTP status code
- `response.raw_body` — the full parsed response body

## Error Handling

```ruby
begin
  client.wallets.get("bad-id")
rescue Circle::NotFoundError => e
  puts e.message       # "Resource not found"
  puts e.http_status   # 404
  puts e.error_code    # Circle-specific error code
rescue Circle::AuthenticationError
  # 401
rescue Circle::ValidationError
  # 400
rescue Circle::RateLimitError
  # 429
rescue Circle::ServerError
  # 500+
rescue Circle::ConnectionError
  # Network error
end
```

## Entity Secret

For developer-controlled wallet write operations, Circle requires an encrypted entity secret ciphertext. The gem handles this automatically when you provide `entity_secret` during client initialization.

To generate a new entity secret:

```ruby
secret = Circle::EntitySecret.generate  # => 64-char hex string
```

## License

MIT
