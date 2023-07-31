# frozen_string_literal: true

require 'test_helper'

describe 'KaChing::ApiV1::Bookings', :vcr do
  before do
    @client = KaChing::ApiClient.new.build_client!
    VCR.insert_cassette name
  end

  after do
    VCR.eject_cassette
  end

  describe 'requests to bookings endpoint' do
    it 'create a deposit' do
      http = nil
      @client.v1.bookings.deposit!(
        tenant_account_id: 'testuser_1',
        amount_cents: 100_00,
        context: { 'foo' => 'bar' },
        year: 2000,
        month: 1,
        day: 11
      )
      res = @client.v1.bookings.deposit!(
        tenant_account_id: 'testuser_1',
        amount_cents: 100_00,
        context: { 'foo' => 'bar' }
      ) do |response|
        http = response
      end
      assert_equal 200, http.status
      assert res.is_a?(Hash)
    end

    it 'get unlocked' do
      http = nil
      res = @client.v1.bookings.unlocked(tenant_account_id: 'testuser_1') do |response|
        http = response
      end
      assert_equal 200, http.status
      assert res.is_a?(Hash)
      assert res['bookings'].is_a?(Array)
      assert res['bookings'].first.is_a?(Hash)
      assert res['bookings'].first['context'].is_a?(Hash)
    end

    it 'creates a withdrawal' do
      http = nil
      res = @client.v1.bookings.withdraw!(
        tenant_account_id: 'testuser_1',
        amount_cents: 50_00,
        context: { 'foo' => 'bar' }
      ) do |response|
        http = response
      end

      assert_equal 200, http.status
      assert res.is_a?(Hash)
    end

    it 'deletes a booking' do
      bookings = @client.v1.bookings.unlocked(tenant_account_id: 'testuser_1')
      booking = bookings['bookings'].last
      booking_id = booking['id']

      http = nil
      res = @client.v1.bookings.drop!(
        tenant_account_id: 'testuser_1',
        booking_id: booking_id
      ) do |response|
        http = response
      end

      assert_equal 200, http.status
      assert res.is_a?(Hash)
    end
  end
end
