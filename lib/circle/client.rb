# frozen_string_literal: true

module Circle
  class Client
    attr_reader :connection, :api_key, :entity_secret

    def initialize(api_key: nil, entity_secret: nil, base_url: nil, **options)
      config = Circle.configuration || Configuration.new
      @api_key = api_key || config.api_key
      @entity_secret = entity_secret || config.entity_secret

      raise ArgumentError, "api_key is required" unless @api_key

      @connection = Connection.new(
        api_key: @api_key,
        base_url: base_url || config.base_url,
        open_timeout: options[:open_timeout] || config.open_timeout,
        read_timeout: options[:read_timeout] || config.read_timeout,
        user_agent: options[:user_agent] || config.user_agent
      )

      @public_key_cache = nil
    end

    def generate_entity_secret_ciphertext
      raise ArgumentError, "entity_secret is required" unless entity_secret

      @public_key_cache ||= developer_account.get_public_key.data["publicKey"]
      EntitySecret.encrypt(entity_secret_hex: entity_secret, public_key_pem: @public_key_cache)
    end

    # Developer-controlled wallet resources
    def developer_account
      @developer_account ||= Resources::DeveloperAccount.new(self)
    end

    def wallet_sets
      @wallet_sets ||= Resources::WalletSets.new(self)
    end

    def wallets
      @wallets ||= Resources::Wallets.new(self)
    end

    def transactions
      @transactions ||= Resources::Transactions.new(self)
    end

    def signing
      @signing ||= Resources::Signing.new(self)
    end

    def tokens
      @tokens ||= Resources::Tokens.new(self)
    end

    def monitored_tokens
      @monitored_tokens ||= Resources::MonitoredTokens.new(self)
    end

    def subscriptions
      @subscriptions ||= Resources::Subscriptions.new(self)
    end

    def faucet
      @faucet ||= Resources::Faucet.new(self)
    end

    def address_validation
      @address_validation ||= Resources::AddressValidation.new(self)
    end

    # User-controlled wallet resources
    def users
      @users ||= Resources::Users.new(self)
    end

    def user_pin
      @user_pin ||= Resources::UserPin.new(self)
    end

    def user_wallets
      @user_wallets ||= Resources::UserWallets.new(self)
    end

    def user_transactions
      @user_transactions ||= Resources::UserTransactions.new(self)
    end

    def user_signing
      @user_signing ||= Resources::UserSigning.new(self)
    end

    # Smart Contract Platform resources
    def contracts
      @contracts ||= Resources::Contracts.new(self)
    end

    def contract_templates
      @contract_templates ||= Resources::ContractTemplates.new(self)
    end

    def event_monitors
      @event_monitors ||= Resources::EventMonitors.new(self)
    end

    def event_logs
      @event_logs ||= Resources::EventLogs.new(self)
    end
  end
end
