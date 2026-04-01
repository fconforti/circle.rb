# frozen_string_literal: true

module Circle
  module Resources
    class EventLogs < Resource
      def list(**params)
        get_request("/contracts/events", params)
      end
    end
  end
end
