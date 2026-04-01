# frozen_string_literal: true

module Circle
  module Resources
    class EventMonitors < Resource
      def create(**params)
        post_request("/contracts/monitors", params)
      end

      def list(**params)
        get_request("/contracts/monitors", params)
      end

      def get(id)
        get_request("/contracts/monitors/#{id}")
      end

      def update(id, **params)
        put_request("/contracts/monitors/#{id}", params)
      end

      def delete(id)
        delete_request("/contracts/monitors/#{id}")
      end
    end
  end
end
