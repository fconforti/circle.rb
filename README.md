# circle.rb

Ruby client for [Circle Web3 Services API](https://developers.circle.com/).

## Installation

```ruby
gem "circle.rb"
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

## Examples

The [`examples/`](examples/) directory contains runnable scripts that demonstrate the gem's features end-to-end on the ETH-SEPOLIA testnet.

### Setup

```bash
cd examples
cp .env.example .env
# Add your CIRCLE_API_KEY to .env
bundle install
bundle exec ruby 00_setup.rb   # generates and registers your entity secret
```

### 00 — Setup

Generates an entity secret, encrypts it with Circle's public key, registers it, and saves the recovery file. You only run this once per Circle account.

```ruby
entity_secret = Circle::EntitySecret.generate
public_key = client.developer_account.get_public_key.data["publicKey"]
ciphertext = Circle::EntitySecret.encrypt(
  entity_secret_hex: entity_secret,
  public_key_pem: public_key
)
client.developer_account.register_entity_secret(
  entity_secret_ciphertext: ciphertext
)
```

### 01 — Wallet Sets & Wallets

Creates a wallet set (a container for wallets) and an ETH-SEPOLIA wallet, then checks token balances. Safe to re-run — reuses existing resources.

```ruby
wallet_set = client.wallet_sets.create(name: "My App Wallets")
wallet = client.wallets.create(
  wallet_set_id: wallet_set.data["walletSet"]["id"],
  blockchains: ["ETH-SEPOLIA"],
  count: 1
)
balances = client.wallets.get_token_balance(wallet_id)
```

### 02 — Transfer EURC

Transfers EURC between two wallets. Estimates the gas fee first, then executes the transfer and polls for confirmation.

```ruby
fee = client.transactions.estimate_transfer_fee(
  wallet_id: source_id,
  token_id: eurc_token_id,
  destination_address: dest_address,
  amounts: ["0.01"]
)

tx = client.transactions.create_transfer(
  wallet_id: source_id,
  token_id: eurc_token_id,
  destination_address: dest_address,
  amounts: ["0.01"],
  fee_level: "MEDIUM"
)
```

### 03 — Check Balances

Lists all your ETH-SEPOLIA wallets and their token balances.

```ruby
wallets = client.wallets.list(blockchain: "ETH-SEPOLIA")
wallets.data["wallets"].each do |w|
  balances = client.wallets.get_token_balance(w["id"])
  balances.data["tokenBalances"].each do |b|
    puts "#{b["token"]["symbol"]}: #{b["amount"]}"
  end
end
```

### 04 — Smart Contracts (Marketplace with 1% Fee)

Deploys a custom `MarketplaceFee` smart contract that splits every EURC payment: 99% to the seller, 1% to a marketplace fee wallet. Demonstrates the full flow: deploy, approve, and execute a contract.

```ruby
# Deploy the contract (constructor takes the fee wallet address)
deploy = client.contracts.deploy(
  name: "MarketplaceFee",
  blockchain: "ETH-SEPOLIA",
  wallet_id: buyer_wallet_id,
  abi_json: contract_abi,
  bytecode: contract_bytecode,
  constructor_parameters: [marketplace_address],
  fee_level: "HIGH"
)

# Approve the contract to spend buyer's EURC
client.transactions.create_contract_execution(
  wallet_id: buyer_wallet_id,
  contract_address: eurc_address,
  abi_function_signature: "approve(address,uint256)",
  abi_parameters: [contract_address, amount.to_s],
  fee_level: "MEDIUM"
)

# Execute the transfer with fee
client.transactions.create_contract_execution(
  wallet_id: buyer_wallet_id,
  contract_address: contract_address,
  abi_function_signature: "transferWithFee(address,address,uint256)",
  abi_parameters: [eurc_address, seller_address, amount.to_s],
  fee_level: "MEDIUM"
)
```

The Solidity source is in [`examples/contracts/MarketplaceFee.sol`](examples/contracts/MarketplaceFee.sol).

### 05 — Gasless Transfer (Gas Station)

Creates a Smart Contract Account (SCA) wallet and sends EURC without any ETH for gas. Circle's Gas Station sponsors the gas fees automatically.

```ruby
# Create an SCA wallet (required for gas sponsorship on EVM)
wallet = client.wallets.create(
  wallet_set_id: wallet_set_id,
  blockchains: ["ETH-SEPOLIA"],
  count: 1,
  account_type: "SCA"
)

# Transfer from SCA wallet — zero ETH, gas is sponsored
client.transactions.create_transfer(
  wallet_id: sca_wallet_id,
  token_id: eurc_token_id,
  destination_address: dest_address,
  amounts: ["0.5"],
  fee_level: "MEDIUM"
)
```

On testnet, gas sponsorship is preconfigured. On mainnet, configure a policy in the [Circle Developer Console](https://console.circle.com).

### 06 — Webhooks

Lists webhook subscriptions and optionally creates a new one. Circle verifies the endpoint is reachable before activating it. Includes a commented Sinatra example for verifying webhook signatures.

```bash
bundle exec ruby 06_webhooks.rb                           # list subscriptions
bundle exec ruby 06_webhooks.rb https://your-webhook-url  # create one
```

```ruby
# Verify webhook signatures in your web server
event = Circle::Webhook.construct_event(
  payload: request.body.read,
  signature: request.env["HTTP_X_CIRCLE_SIGNATURE"],
  public_key: public_key_b64
)
```

## License

MIT
