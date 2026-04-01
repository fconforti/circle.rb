# frozen_string_literal: true

require_relative "circle/version"
require_relative "circle/configuration"
require_relative "circle/errors"
require_relative "circle/util"
require_relative "circle/response"
require_relative "circle/connection"
require_relative "circle/resource"
require_relative "circle/entity_secret"
require_relative "circle/webhook"
require_relative "circle/pagination"
require_relative "circle/client"

# Resources
require_relative "circle/resources/developer_account"
require_relative "circle/resources/wallet_sets"
require_relative "circle/resources/wallets"
require_relative "circle/resources/transactions"
require_relative "circle/resources/signing"
require_relative "circle/resources/tokens"
require_relative "circle/resources/monitored_tokens"
require_relative "circle/resources/subscriptions"
require_relative "circle/resources/faucet"
require_relative "circle/resources/address_validation"
require_relative "circle/resources/users"
require_relative "circle/resources/user_pin"
require_relative "circle/resources/user_wallets"
require_relative "circle/resources/user_transactions"
require_relative "circle/resources/user_signing"
require_relative "circle/resources/contracts"
require_relative "circle/resources/contract_templates"
require_relative "circle/resources/event_monitors"
require_relative "circle/resources/event_logs"

module Circle
  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    def reset_configuration!
      self.configuration = Configuration.new
    end
  end
end
