# frozen_string_literal: true

module Circle
  module Resources
    class AddressValidation < Resource
      def validate(**params)
        post_request("/transactions/validateAddress", params)
      end
    end
  end
end
