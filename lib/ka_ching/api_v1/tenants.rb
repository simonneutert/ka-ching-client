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
      def all(page: 1, per_page: 1000)
        all_url = build_url
        res = get("#{all_url}/all") do |req|
          req.headers['Content-Type'] = 'application/json'
          req.body = { page: page, per_page: per_page }.to_json
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
        res = get("#{active_url}/active") do |req|
          req.headers['Content-Type'] = 'application/json'
          req.body = { page: page, per_page: per_page }.to_json
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
        res = get("#{inactive_url}/inactive}") do |req|
          req.headers['Content-Type'] = 'application/json'
          req.body = { page: page, per_page: per_page }.to_json
        end
        yield res if block_given?
        JSON.parse(res.body)
      end

      private

      def build_url(tenant_account_id: nil)
        if tenant_account_id
          "#{@api_url}/tenants/#{tenant_account_id}"
        else
          "#{@api_url}/tenants"
        end
      end
    end
  end
end
