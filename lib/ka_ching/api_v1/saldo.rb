# frozen_string_literal: true

module KaChing
  module ApiV1
    #
    # Saldo Endpoint for the KaChing API V1
    #
    class Saldo
      extend Forwardable

      def_delegators :@conn, :get, :post, :put, :patch, :delete

      def initialize(conn:, api_url:)
        @conn = conn
        @api_url = api_url
      end

      #
      # Get the current saldo (in cents)
      #
      # @param [String] tenant_account_id without the tenant database namespace,
      #     e.g. 'user_1' instead of 'kaching_tenant_user_1'
      #
      # @yield [Faraday::Response] The response from the server
      # @return [Hash] The current saldo
      #
      def current(tenant_account_id:)
        res = get(build_url(tenant_account_id: tenant_account_id)) do |req|
          req.headers['Content-Type'] = 'application/json'
        end
        yield res if block_given?
        JSON.parse(res.body)
      end

      private

      def build_url(tenant_account_id:)
        "#{@api_url}/#{tenant_account_id}/saldo"
      end
    end
  end
end
