# frozen_string_literal: true

module Circle
  module Resources
    class UserTransactions < Resource
      def create_transfer(**params)
        post_request("/user/transactions/transfer", params)
      end

      def create_contract_execution(**params)
        post_request("/user/transactions/contractExecution", params)
      end

      def list(**params)
        get_request("/transactions", params)
      end

      def get(id, **params)
        get_request("/transactions/#{id}", params)
      end

      def accelerate(id, **params)
        post_request("/user/transactions/#{id}/accelerate", params)
      end

      def cancel(id, **params)
        post_request("/user/transactions/#{id}/cancel", params)
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
