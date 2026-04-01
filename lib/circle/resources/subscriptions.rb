# frozen_string_literal: true

module Circle
  module Resources
    class Subscriptions < Resource
      NOTIFICATIONS_PATH = "/v2/notifications"

      def create(**params)
        body = Util.deep_snake_to_camel(params)
        body["idempotencyKey"] ||= SecureRandom.uuid
        client.connection.post("#{NOTIFICATIONS_PATH}/subscriptions", body)
      end

      def list
        client.connection.get("#{NOTIFICATIONS_PATH}/subscriptions")
      end

      def get(id)
        client.connection.get("#{NOTIFICATIONS_PATH}/subscriptions/#{id}")
      end

      def update(id, **params)
        client.connection.put("#{NOTIFICATIONS_PATH}/subscriptions/#{id}", Util.deep_snake_to_camel(params))
      end

      def delete(id)
        client.connection.delete("#{NOTIFICATIONS_PATH}/subscriptions/#{id}")
      end

      def get_notification_signature(id)
        client.connection.get("#{NOTIFICATIONS_PATH}/subscriptions/#{id}/notificationSignature")
      end
    end
  end
end
