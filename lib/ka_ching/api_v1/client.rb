# frozen_string_literal: true

module KaChing
  module ApiV1
    #
    # The client class is the main entry point for the KaChing API V1.
    #
    class Client
      def initialize(conn:, base_url:)
        @conn = conn
        @base_url = base_url
        @api_url = '/ka-ching/api/v1'
      end

      #
      # The admin endpoint interface for the KaChing API V1
      #
      # @return [KaChing::ApiV1::Admin] The admin endpoint interface
      #
      def admin
        @_admin ||= KaChing::ApiV1::Admin.new(conn: @conn, api_url: @api_url)
      end

      #
      # The tenants endpoint interface for the KaChing API V1
      #
      # @return [KaChing::ApiV1::Tenants] The tenants endpoint interface
      #
      def tenants
        @_tenants ||= KaChing::ApiV1::Tenants.new(conn: @conn, api_url: @api_url)
      end

      #
      # The saldo endpoint interface for the KaChing API V1
      #
      # @return [KaChing::ApiV1::Saldo] The saldo endpoint interface
      #
      def saldo
        @_saldo ||= KaChing::ApiV1::Saldo.new(conn: @conn, api_url: @api_url)
      end

      #
      # The booking endpoint interface for the KaChing API V1
      #
      # @return [KaChing::ApiV1::Bookings] The booking endpoint interface
      #
      def bookings
        @_bookings ||= KaChing::ApiV1::Bookings.new(conn: @conn, api_url: @api_url)
      end

      #
      # The lockings endpoint interface for the KaChing API V1
      #
      # @return [KaChing::ApiV1::Lockings] The lockings endpoint interface
      #
      def lockings
        @_lockings ||= KaChing::ApiV1::Lockings.new(conn: @conn, api_url: @api_url)
      end

      #
      # The audit_logs endpoint interface for the KaChing API V1
      #
      # @return [KaChing::ApiV1::AuditLogs] The audit_logs endpoint interface
      #
      def audit_logs
        @_audit_logs ||= KaChing::ApiV1::AuditLogs.new(conn: @conn, api_url: @api_url)
      end
    end
  end
end
