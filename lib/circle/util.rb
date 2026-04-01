# frozen_string_literal: true

module Circle
  module Util
    module_function

    def deep_snake_to_camel(params)
      case params
      when Hash
        params.each_with_object({}) do |(key, value), result|
          camel_key = snake_to_camel(key.to_s)
          result[camel_key] = deep_snake_to_camel(value)
        end
      when Array
        params.map { |item| deep_snake_to_camel(item) }
      else
        params
      end
    end

    def snake_to_camel(str)
      return str unless str.include?("_")

      parts = str.split("_")
      parts[0] + parts[1..].map(&:capitalize).join
    end
  end
end
