# frozen_string_literal: true

module Circle
  class Pagination
    include Enumerable

    DEFAULT_PAGE_SIZE = 10

    def initialize(resource:, path:, params: {}, key: nil)
      @resource = resource
      @path = path
      @params = params
      @key = key
    end

    def each(&block)
      return enum_for(:each) unless block_given?

      params = @params.dup
      loop do
        response = @resource.send(:get_request, @path, params)
        items = @key ? response.data[@key] : response.data
        break if items.nil? || !items.is_a?(Array) || items.empty?

        items.each(&block)

        page_size = params[:page_size] || params[:pageSize] || DEFAULT_PAGE_SIZE
        break if items.size < page_size

        params = params.merge(page_after: items.last["id"])
      end
    end
  end
end
