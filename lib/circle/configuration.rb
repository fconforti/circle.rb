# frozen_string_literal: true

module Circle
  class Configuration
    attr_accessor :api_key, :entity_secret, :base_url, :open_timeout, :read_timeout, :user_agent

    def initialize
      @base_url = "https://api.circle.com"
      @open_timeout = 30
      @read_timeout = 60
      @user_agent = "circle-sdk-ruby/#{Circle::VERSION}"
    end
  end
end
