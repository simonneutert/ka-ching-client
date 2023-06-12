# frozen_string_literal: true

module KaChing
  module ApiV1
    #
    # Bookings Endpoint for the KaChing API V1
    #
    class Bookings
      extend Forwardable

      def_delegators :@conn, :get, :post, :put, :patch, :delete

      def initialize(conn:, api_url:)
        @conn = conn
        @api_url = api_url
      end

      #
      # Deposit money to the current tenant account
      #
      # @param [String] tenant_account_id without the tenant database namespace,
      #     e.g. 'user_1' instead of 'kaching_tenant_user_1'
      # @param [Integer] amount_cents the amount to deposit in cents
      # @param [Integer] year the year of the booking
      # @param [Integer] month the month of the booking
      # @param [Integer] day the day of the booking
      # @param [Hash] context additional context information
      #
      # @yield [Faraday::Response] The response from the server
      # @return [Hash] containing the booking details
      #
      def deposit!(tenant_account_id:,
                   amount_cents:,
                   year: Date.today.year,
                   month: Date.today.month,
                   day: Date.today.day,
                   context: {})
        res = create!(tenant_account_id: tenant_account_id,
                      booking: {
                        action: :deposit,
                        amount_cents: amount_cents,
                        year: year,
                        month: month,
                        day: day,
                        context: context
                      })
        yield res if block_given?
        JSON.parse(res.body)
      end

      #
      # Withdraw money to the current tenant account
      #
      # @param [String] tenant_account_id without the tenant database namespace,
      #     e.g. 'user_1' instead of 'kaching_tenant_user_1'
      # @param [Integer] amount_cents the amount to deposit in cents
      # @param [Integer] year the year of the booking
      # @param [Integer] month the month of the booking
      # @param [Integer] day the day of the booking
      # @param [Hash] context additional context information
      #
      # @yield [Faraday::Response] The response from the server
      # @return [Hash] containing the booking details
      #
      def withdraw!(tenant_account_id:,
                    amount_cents:,
                    year: Date.today.year,
                    month: Date.today.month,
                    day: Date.today.day,
                    context: {})
        res = create!(tenant_account_id: tenant_account_id, booking: {
                        action: :withdraw,
                        amount_cents: amount_cents,
                        year: year,
                        month: month,
                        day: day,
                        context: context
                      })
        yield res if block_given?
        JSON.parse(res.body)
      end

      #
      # drops/deletes a booking
      #
      # @param [String] tenant_account_id without the tenant database namespace,
      #     e.g. 'user_1' instead of 'kaching_tenant_user_1'
      # @param [String] booking_id uuid of the booking
      #
      # @yield [Faraday::Response] The response from the server
      # @return [Hash] containing the booking details
      #
      def drop!(tenant_account_id:, booking_id:)
        drop_url = "#{build_url(tenant_account_id: tenant_account_id)}/#{booking_id}"
        res = delete(drop_url) do |req|
          req.headers['Content-Type'] = 'application/json'
          req.body = { id: booking_id }.to_json
        end
        yield res if block_given?
        JSON.parse(res.body)
      end

      #
      # returns all unlocked bookings for a tenant
      #
      # @param [String] tenant_account_id without the tenant database namespace,
      #     e.g. 'user_1' instead of 'kaching_tenant_user_1'
      #
      # @yield [Faraday::Response] The response from the server
      # @return [Hash] containing the booking details
      #
      def unlocked(tenant_account_id:)
        unlocked_url = "#{build_url(tenant_account_id: tenant_account_id)}/unlocked"
        res = get(unlocked_url) do |req|
          req.headers['Content-Type'] = 'application/json'
        end
        yield res if block_given?
        JSON.parse(res.body)
      end

      private

      #
      # post action to the current tenant account
      #
      # @param [String] tenant_account_id without the tenant database namespace,
      #     e.g. 'user_1' instead of 'kaching_tenant_user_1'
      # @param [Hash] booking the booking details
      # @option booking [String] :action the action to perform, either :deposit or :withdraw
      # @option booking [Integer] :amount_cents the amount to deposit in cents
      # @option booking [Integer] :year the year of the booking
      # @option booking [Integer] :month the month of the booking
      # @option booking [Integer] :day the day of the booking
      # @option booking [Hash] :context any additional context information
      #
      # @return [Faraday::Response] The response from the server
      #
      def create!(tenant_account_id:, booking:)
        create_url = build_url(tenant_account_id: tenant_account_id)
        post(create_url) do |req|
          req.headers['Content-Type'] = 'application/json'
          req.body = booking.to_json
        end
      end

      def build_url(tenant_account_id:)
        "#{@api_url}/#{tenant_account_id}/bookings"
      end
    end
  end
end
