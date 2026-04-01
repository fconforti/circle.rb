# frozen_string_literal: true

module Circle
  module Resources
    class Contracts < Resource
      def deploy(**params)
        post_request("/contracts/deploy", params, inject_entity_secret: true)
      end

      def estimate_deployment_fee(**params)
        post_request("/contracts/deploy/estimateFee", params)
      end

      def import(**params)
        post_request("/contracts/import", params)
      end

      def list(**params)
        get_request("/contracts", params)
      end

      def get(id)
        get_request("/contracts/#{id}")
      end

      def update(id, **params)
        put_request("/contracts/#{id}", params)
      end

      def query(**params)
        post_request("/contracts/query", params)
      end
    end
  end
end
