# frozen_string_literal: true

module Circle
  module Resources
    class Faucet < Resource
      def request_tokens(**params)
        post_request("/faucet/drip", params)
      end
    end
  end
end
