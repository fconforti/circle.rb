# frozen_string_literal: true

module Circle
  module Resources
    class UserPin < Resource
      def create(**params)
        post_request("/user/pin", params)
      end

      def create_with_wallets(**params)
        post_request("/user/pin/wallets", params)
      end

      def update(**params)
        put_request("/user/pin", params)
      end

      def restore(**params)
        post_request("/user/pin/restore", params)
      end
    end
  end
end
