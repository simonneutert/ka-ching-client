# frozen_string_literal: true

module KaChing
  module ApiV1
    #
    # Lockings Endpoint for the KaChing API V1
    #
    class Lockings
      extend Forwardable

      def_delegators :@conn, :get, :post, :put, :patch, :delete

      def initialize(conn:, api_url:)
        @conn = conn
        @api_url = api_url
      end

      #
      # Locks the bookings for a specific day
      #
      # @param [String] action should be "lock"
      # @param [Integer] amount_cents_saldo_user_counted what the user counted as saldo
      # @param [Integer] year
      # @param [Integer] month
      # @param [Integer] day
      # @param [Hash] context object with additional information stored with the locking
      #
      # @yield [Faraday::Response] The response from the server
      # @return [Hash] the locking
      #
      def lock!(tenant_account_id:,
                amount_cents_saldo_user_counted:,
                year: Date.today.year,
                month: Date.today.month,
                day: Date.today.day,
                context: {})
        locking = {
          action: :lock,
          amount_cents_saldo_user_counted: amount_cents_saldo_user_counted,
          year: Integer(year),
          month: Integer(month),
          day: Integer(day),
          context: context
        }
        res = post(build_url(tenant_account_id: tenant_account_id)) do |req|
          req.headers['Content-Type'] = 'application/json'
          req.body = locking.to_json
        end
        yield res if block_given?
        res = JSON.parse(res.body)
        res['record']['bookings_json'] = JSON.parse(res['record']['bookings_json'])
        res['context'] = JSON.parse(JSON.parse(res['context']))
        res
      end

      #
      # Unlocks last locking
      #
      # @yield [Faraday::Response] The response from the server
      # @return [Hash]
      #
      def unlock!(tenant_account_id:)
        res = delete(build_url(tenant_account_id: tenant_account_id)) do |req|
          req.headers['Content-Type'] = 'application/json'
        end
        yield res if block_given?
        res = JSON.parse(res.body)
        res['bookings_json'] = JSON.parse(res['bookings_json'])
        res['context'] = JSON.parse(JSON.parse(res['context']))
        res
      end

      def all(tenant_account_id:, page: 1, per_page: 10)
        res = get(build_url(tenant_account_id: tenant_account_id), { page: page, per_page: per_page }) do |req|
          req.headers['Content-Type'] = 'application/json'
        end
        yield res if block_given?
        JSON.parse(res.body)
      end

      #
      # Get all lockings for a given year
      #
      # @yield [Faraday::Response] The response from the server
      # @return [Hash]
      #
      def of_year(tenant_account_id:, year:, page: 1, per_page: 100)
        res = get(build_url(tenant_account_id: tenant_account_id),
                  { year: year, page: page, per_page: per_page }) do |req|
          req.headers['Content-Type'] = 'application/json'
          req.body = { year: year }.to_json
        end
        yield res if block_given?
        JSON.parse(res.body)
      end

      #
      # Get all lockings for a given year in month
      #
      # @yield [Faraday::Response] The response from the server
      # @return [Hash]
      #
      def of_year_month(tenant_account_id:, year:, month:, page: 1, per_page: 100)
        res = get(build_url(tenant_account_id: tenant_account_id),
                  { year: year, month: month, page: page, per_page: per_page }) do |req|
          req.headers['Content-Type'] = 'application/json'
          req.body = { year: year, month: month }.to_json
        end
        yield res if block_given?
        JSON.parse(res.body)
      end

      #
      # Get all lockings for a given year in month at day
      #
      # @yield [Faraday::Response] The response from the server
      # @return [Hash]
      #
      def of_year_month_day(tenant_account_id:, year:, month:, day:)
        res = get(build_url(tenant_account_id: tenant_account_id).to_s,
                  { year: year, month: month, day: day, page: page, per_page: per_page }) do |req|
          req.headers['Content-Type'] = 'application/json'
          req.body = { year: year, month: month, day: day }.to_json
        end
        yield res if block_given?
        JSON.parse(res.body)
      end

      private

      def build_url(tenant_account_id:)
        "#{@api_url}/#{tenant_account_id}/lockings"
      end
    end
  end
end
