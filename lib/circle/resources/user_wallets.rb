# frozen_string_literal: true

module Circle
  module Resources
    class UserWallets < Resource
      def create(**params)
        post_request("/user/wallets", params)
      end

      def list(**params)
        get_request("/wallets", params)
      end

      def get(id, **params)
        get_request("/wallets/#{id}", params)
      end

      def update(id, **params)
        put_request("/wallets/#{id}", params)
      end

      def get_token_balance(id, **params)
        get_request("/wallets/#{id}/balances", params)
      end

      def get_nft_balance(id, **params)
        get_request("/wallets/#{id}/nfts", params)
      end
    end
  end
end
