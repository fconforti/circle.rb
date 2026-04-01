# frozen_string_literal: true

module Circle
  module Resources
    class Tokens < Resource
      def get(id)
        get_request("/tokens/#{id}")
      end
    end
  end
end
