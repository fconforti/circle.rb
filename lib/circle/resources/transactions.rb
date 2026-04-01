# frozen_string_literal: true

module Circle
  module Resources
    class Transactions < Resource
      def create_transfer(**params)
        post_request("/developer/transactions/transfer", params, inject_entity_secret: true)
      end

      def create_contract_execution(**params)
        post_request("/developer/transactions/contractExecution", params, inject_entity_secret: true)
      end

      def list(**params)
        get_request("/transactions", params)
      end

      def get(id, **params)
        get_request("/transactions/#{id}", params)
      end

      def accelerate(id, **params)
        post_request("/developer/transactions/#{id}/accelerate", params, inject_entity_secret: true)
      end

      def cancel(id, **params)
        post_request("/developer/transactions/#{id}/cancel", params, inject_entity_secret: true)
      end

      def estimate_transfer_fee(**params)
        post_request("/transactions/transfer/estimateFee", params)
      end

      def estimate_contract_execution_fee(**params)
        post_request("/transactions/contractExecution/estimateFee", params)
      end
    end
  end
end
