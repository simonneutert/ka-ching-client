# frozen_string_literal: true

require 'test_helper'

describe 'KaChing::ApiV1::Lockings', :vcr do
  before do
    @client = KaChing::ApiClient.new.build_client!
    VCR.insert_cassette name
  end

  after do
    VCR.eject_cassette
  end

  describe 'requests to lockings endpoint' do
    it 'locks' do
      http_res_lock = nil
      res_lock = @client.v1
                        .lockings
                        .lock!(tenant_account_id: 'testuser_1',
                               amount_cents_saldo_user_counted: 100_00,
                               context: { 'foo' => 'bar' },
                               year: 2000,
                               month: 1,
                               day: 1) do |response|
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

      assert_kind_of Hash, res_lock_record
      assert_equal %w[active
                      bookings
                      context
                      created_at
                      id
                      realized_at
                      saldo_cents_calculated
                      amount_cents_saldo_user_counted
                      updated_at].sort, res_lock_record.keys.sort
    end
    it 'locks and unlocks again' do
      http_res_lock = nil
      res_lock = @client.v1
                        .lockings
                        .lock!(tenant_account_id: 'testuser_1',
                               amount_cents_saldo_user_counted: 100_00,
                               year: 2000,
                               month: 1,
                               day: 31,
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

      assert_kind_of Hash, res_lock_record
      assert_equal %w[active
                      bookings
                      context
                      created_at
                      id
                      realized_at
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
                      bookings
                      context
                      created_at
                      id
                      realized_at
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
      assert_kind_of(Array, res_lock['items'])
      assert_kind_of(Hash, res_lock['items'].first)
    end
    it 'loads active lockings' do
      http_res_lock = nil
      res_lock = @client.v1
                        .lockings
                        .active(tenant_account_id: 'testuser_1',
                                year: 2000,
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
      assert_kind_of(Array, res_lock['items'])
      assert_kind_of(Hash, res_lock['items'].first)
      assert_kind_of(Hash, res_lock['items'].first['context'])
      assert(res_lock['items'].all? { |item| item['active'] == true })
    end
    it 'loads inactive lockings' do
      http_res_lock = nil
      res_lock = @client.v1
                        .lockings
                        .inactive(tenant_account_id: 'testuser_1',
                                  year: 2000,
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
      assert_kind_of(Array, res_lock['items'])
      assert_kind_of(Hash, res_lock['items'].first)
      assert_kind_of(Hash, res_lock['items'].first['bookings'].first['context'])
      assert_kind_of(Hash, res_lock['items'].first['context'])
      assert(res_lock['items'].all? { |item| item['active'] == false })
    end
  end
end
