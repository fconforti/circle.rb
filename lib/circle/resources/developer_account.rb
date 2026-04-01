# frozen_string_literal: true

module Circle
  module Resources
    class DeveloperAccount < Resource
      def get_public_key
        get_request("/config/entity/publicKey")
      end
    end
  end
end
