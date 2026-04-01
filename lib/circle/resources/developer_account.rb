# frozen_string_literal: true

module Circle
  module Resources
    class DeveloperAccount < Resource
      def get_public_key
        get_request("/config/entity/publicKey")
      end

      def register_entity_secret(**params)
        post_request("/config/entity/entitySecret", params)
      end
    end
  end
end
