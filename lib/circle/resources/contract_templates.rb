# frozen_string_literal: true

module Circle
  module Resources
    class ContractTemplates < Resource
      def deploy(template_id, **params)
        post_request("/contracts/templates/#{template_id}/deploy", params, inject_entity_secret: true)
      end

      def estimate_deployment_fee(template_id, **params)
        post_request("/contracts/templates/#{template_id}/deploy/estimateFee", params)
      end
    end
  end
end
