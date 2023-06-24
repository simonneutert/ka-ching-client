# frozen_string_literal: true

module KaChing
  module ApiV1
    #
    # Admin Endpoint for the KaChing API V1
    #
    class Admin
      extend Forwardable

      def_delegators :@conn, :get, :post, :put, :patch, :delete

      def initialize(conn:, api_url:)
        @conn = conn
        @api_url = api_url
      end

      #
      # gets the details of a tenant database
      #
      # @param [String] full tenant_account_id with its database namespace, e.g. 'kaching_tenant_user_1'
      #
      # @yield [Faraday::Response] The response from the server
      # @return [Hash] containing the details of the tenant database
      #
      def details(tenant_account_id:)
        admin_tenant_url = build_url(tenant_account_id: tenant_account_id)
        res = get(admin_tenant_url) do |req|
          req.headers['Content-Type'] = 'application/json'
        end
        yield res if block_given?
        JSON.parse(res.body)
      end

      #
      # creates a new tenant database
      #
      # @param [String] tenant_account_id without its database namespace, e.g.
      #     'user_1' instead of 'kaching_tenant_user_1'
      #
      # @yield [Faraday::Response] The response from the server
      # @return [Hash]
      #
      def create!(tenant_account_id:)
        res = post(build_url) do |req|
          req.headers['Content-Type'] = 'application/json'
          req.body = { tenant_account_id: tenant_account_id }.to_json
        end
        yield res if block_given?
        JSON.parse(res.body)
      end

      #
      # resets a tenant database
      #
      # @param [String] tenant_account_id without its database namespace
      #
      # @return [Hash] containing the details of the response
      #
      def reset!(tenant_account_id:)
        reset_url = "#{build_url(tenant_account_id: tenant_account_id)}/reset"
        res = post(reset_url) do |req|
          req.headers['Content-Type'] = 'application/json'
        end
        yield res if block_given?
        JSON.parse(res.body)
      end

      #
      # drops a tenant database
      #
      # @param [String] tenant_account_id without its database namespace,
      #     e.g. 'user_1' instead of 'kaching_tenant_user_1'
      #
      # @yield [Faraday::Response] The response from the server
      # @return [Hash]
      #
      def drop!(tenant_account_id:)
        res = delete(build_url) do |req|
          req.headers['Content-Type'] = 'application/json'
          req.body = { tenant_account_id: tenant_account_id }.to_json
        end
        yield res if block_given?
        JSON.parse(res.body)
      end

      private

      def build_url(tenant_account_id: nil)
        if tenant_account_id
          "#{@api_url}/admin/#{tenant_account_id}"
        else
          "#{@api_url}/admin/"
        end
      end
    end
  end
end
