# frozen_string_literal: true

module Circle
  module Resources
    class MonitoredTokens < Resource
      def create(**params)
        post_request("/config/entity/monitoredTokens", params)
      end

      def list(**params)
        get_request("/config/entity/monitoredTokens", params)
      end

      def update(**params)
        put_request("/config/entity/monitoredTokens", params)
      end

      def delete(**params)
        delete_request("/config/entity/monitoredTokens", params)
      end

      def update_scope(**params)
        put_request("/config/entity/monitoredTokens/scope", params)
      end
    end
  end
end
