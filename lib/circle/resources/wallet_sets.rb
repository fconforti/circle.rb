# frozen_string_literal: true

module Circle
  module Resources
    class WalletSets < Resource
      def create(**params)
        post_request("/developer/walletSets", params, inject_entity_secret: true)
      end

      def list(**params)
        get_request("/walletSets", params)
      end

      def get(id)
        get_request("/walletSets/#{id}")
      end

      def update(id, **params)
        put_request("/walletSets/#{id}", params)
      end
    end
  end
end
