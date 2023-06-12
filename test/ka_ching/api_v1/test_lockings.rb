# frozen_string_literal: true

require 'test_helper'

describe 'KaChing::ApiV1::Lockings', :vcr do
  before do
    @client = KaChing::ApiClient.new.build_client!
  end

  describe 'requests to lockings endpoint' do
    it 'locks and unlocks again' do
      http_res_lock = nil
      res_lock = @client.v1
                        .lockings
                        .lock!(tenant_account_id: 'testuser_1',
                               amount_cents_saldo_user_counted: 100_00,
                               context: { 'foo' => 'bar' }) do |response|
                                 http_res_lock = response
                               end
      assert_equal 200, http_res_lock.status
      res_lock.is_a?(Hash)

      assert_equal %w[context
                      diff
                      record
                      saldo
                      status], res_lock.keys.sort

      res_lock_record = res_lock['record']
      assert res_lock_record.is_a?(Hash)
      assert_equal %w[active
                      bookings_json
                      context
                      created_at
                      id
                      realized
                      saldo_cents_calculated
                      amount_cents_saldo_user_counted
                      updated_at].sort, res_lock_record.keys.sort

      http_res_unlock = nil
      res_unlock = @client.v1
                          .lockings
                          .unlock!(tenant_account_id: 'testuser_1') do |response|
        http_res_unlock = response
      end
      assert_equal 200, http_res_unlock.status
      res_unlock.is_a?(Hash)

      assert_equal %w[active
                      bookings_json
                      context
                      created_at
                      id
                      realized
                      saldo_cents_calculated
                      amount_cents_saldo_user_counted
                      updated_at].sort, res_unlock.keys.sort
    end
    it 'loads paginated results' do
      http_res_lock = nil
      res_lock = @client.v1
                        .lockings
                        .all(tenant_account_id: 'testuser_1',
                             page: 1,
                             per_page: 10) do |response|
        http_res_lock = response
      end
      assert_equal 200, http_res_lock.status
      res_lock.is_a?(Hash)
      assert_equal(%w[current_page
                      current_page_record_count
                      current_page_record_range
                      first_page
                      items
                      last_page
                      next_page
                      page_count
                      page_range
                      page_size
                      pagination_record_count
                      prev_page].sort, res_lock.keys.sort)
      assert(res_lock['items'].is_a?(Array))
      assert(res_lock['items'].first.is_a?(Hash))
    end
  end
end
