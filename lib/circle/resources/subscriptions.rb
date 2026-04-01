# frozen_string_literal: true

module Circle
  module Resources
    class Subscriptions < Resource
      def create(**params)
        post_request("/subscriptions", params)
      end

      def list
        get_request("/subscriptions")
      end

      def get(id)
        get_request("/subscriptions/#{id}")
      end

      def update(id, **params)
        put_request("/subscriptions/#{id}", params)
      end

      def delete(id)
        delete_request("/subscriptions/#{id}")
      end

      def get_notification_signature(id)
        get_request("/subscriptions/#{id}/notificationSignature")
      end
    end
  end
end
