# frozen_string_literal: true

module Circle
  module Resources
    class UserSigning < Resource
      def sign_message(**params)
        post_request("/user/sign/message", params)
      end

      def sign_typed_data(**params)
        post_request("/user/sign/typedData", params)
      end

      def sign_transaction(**params)
        post_request("/user/sign/transaction", params)
      end
    end
  end
end
