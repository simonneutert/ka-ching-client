# frozen_string_literal: true

module KaChing
  module ApiV1
    #
    # Tenants Endpoint for the KaChing API V1
    #
    class Tenants
      extend Forwardable

      def_delegators :@conn, :get, :post, :put, :patch, :delete

      def initialize(conn:, api_url:)
        @conn = conn
        @api_url = api_url
      end

      #
      # Get all tenants paginated
      #
      # @param [Integer] page The page number to fetch
      #
      # @return [Array<Hash>] An array of tenant detail hashes
      #
      def all(page: 1)
        all_url = build_url
        res = get("#{all_url}/all/#{page}") do |req|
          req.headers['Content-Type'] = 'application/json'
        end
        yield res if block_given?
        JSON.parse(res.body)
      end

      #
      # Get all active tenants paginated
      #
      # @param [Integer] page The page number to fetch
      #
      # @return [Array<Hash>] An array of tenant detail hashes
      #
      def active(page: 1)
        active_url = build_url
        res = get("#{active_url}/active/#{page}}") do |req|
          req.headers['Content-Type'] = 'application/json'
        end
        yield res if block_given?
        JSON.parse(res.body)
      end

      #
      # Get all inactive tenants paginated
      #
      # @param [Integer] page The page number to fetch
      #
      # @return [Array<Hash>] An array of tenant detail hashes
      #
      def inactive(page: 1)
        inactive_url = build_url
        res = get("#{inactive_url}/all/#{page}}") do |req|
          req.headers['Content-Type'] = 'application/json'
        end
        yield res if block_given?
        JSON.parse(res.body)
      end

      private

      def build_url
        "#{@api_url}/tenants"
      end
    end
  end
end
