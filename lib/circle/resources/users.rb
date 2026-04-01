# frozen_string_literal: true

module Circle
  module Resources
    class Users < Resource
      def create(**params)
        post_request("/users", params)
      end

      def list(**params)
        get_request("/users", params)
      end

      def get(id)
        get_request("/users/#{id}")
      end

      def get_status(user_token:)
        get_request("/user", { user_token: user_token })
      end

      def create_token(**params)
        post_request("/users/token", params)
      end

      def refresh_token(**params)
        post_request("/user/token/refresh", params)
      end

      def create_device_token_social(**params)
        post_request("/users/social/token", params)
      end

      def create_device_token_email(**params)
        post_request("/users/email/token", params)
      end

      def resend_otp(**params)
        post_request("/users/resendOTP", params)
      end
    end
  end
end
