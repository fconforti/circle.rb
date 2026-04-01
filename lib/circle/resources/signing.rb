# frozen_string_literal: true

module Circle
  module Resources
    class Signing < Resource
      def sign_message(**params)
        post_request("/developer/sign/message", params, inject_entity_secret: true)
      end

      def sign_typed_data(**params)
        post_request("/developer/sign/typedData", params, inject_entity_secret: true)
      end

      def sign_transaction(**params)
        post_request("/developer/sign/transaction", params, inject_entity_secret: true)
      end

      def sign_delegate_action(**params)
        post_request("/developer/sign/delegateAction", params, inject_entity_secret: true)
      end
    end
  end
end
