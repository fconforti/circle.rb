# frozen_string_literal: true

module Circle
  module Resources
    class Wallets < Resource
      def create(**params)
        post_request("/developer/wallets", params, inject_entity_secret: true)
      end

      def list(**params)
        get_request("/wallets", params)
      end

      def get(id)
        get_request("/wallets/#{id}")
      end

      def update(id, **params)
        put_request("/wallets/#{id}", params)
      end

      def derive(id, **params)
        post_request("/developer/wallets/#{id}/derive", params, inject_entity_secret: true)
      end

      def get_token_balance(id, **params)
        get_request("/wallets/#{id}/balances", params)
      end

      def get_nft_balance(id, **params)
        get_request("/wallets/#{id}/nfts", params)
      end

      def list_with_balances(**params)
        get_request("/wallets/balances", params)
      end
    end
  end
end
