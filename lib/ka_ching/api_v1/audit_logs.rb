# frozen_string_literal: true

module KaChing
  module ApiV1
    #
    # AuditLog Endpoint for the KaChing API V1
    #
    class AuditLogs
      extend Forwardable

      def_delegators :@conn, :get, :post, :put, :patch, :delete

      def initialize(conn:, api_url:)
        @conn = conn
        @api_url = api_url
      end

      #
      # Get all bookings for the current tenant of a specific year
      #
      # @param [String] tenant_account_id
      # @param [Integer] year
      #
      # @yield [Faraday::Response] The response from the server
      # @return [Hash] containing the bookings as array
      #
      def of_year(tenant_account_id:, year:)
        res = get(build_url(tenant_account_id: tenant_account_id),
                  { year: year })

        yield res if block_given?
        JSON.parse(res.body)['audit_logs']
      end

      #
      # Get all bookings for the current tenant of a specific year, month
      #
      # @param [String] tenant_account_id
      # @param [Integer] year
      # @param [Integer] month
      #
      # @yield [Faraday::Response] The response from the server
      # @return [Hash] containing the bookings as array
      #
      def of_year_month(tenant_account_id:, year:, month:)
        res = get(build_url(tenant_account_id: tenant_account_id),
                  { year: year, month: month })
        yield res if block_given?
        JSON.parse(res.body)['audit_logs']
      end

      #
      # Get all bookings for the current tenant of a specific year, month, day
      #
      # @param [String] tenant_account_id
      # @param [Integer] year
      # @param [Integer] month
      # @param [Integer] day
      #
      # @yield [Faraday::Response] The response from the server
      # @return [Hash] containing the bookings as array
      #
      def of_year_month_day(tenant_account_id:, year:, month:, day:)
        res = get(build_url(tenant_account_id: tenant_account_id),
                  { year: year, month: month, day: day })
        yield res if block_given?
        JSON.parse(res.body)['audit_logs']
      end

      private

      #
      # build the url for the bookings endpoint
      #
      # @param [String] tenant_account_id
      # @param [Integer,nil] year
      # @param [Integer,nil] month
      # @param [Integer,nil] day
      #
      # @return [<Type>] <description>
      #
      def build_url(tenant_account_id:)
        "#{@api_url}/#{tenant_account_id}/auditlogs"
      end
    end
  end
end
