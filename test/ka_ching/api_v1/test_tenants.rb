# frozen_string_literal: true

require 'test_helper'

describe 'KaChing::ApiV1::Tenants', :vcr do
  before do
    custom_faraday = Faraday.new(url: 'http://localhost:9292') do |faraday|
      faraday.response :logger, nil, { bodies: { request: true, response: true } }
    end

    @client = KaChing::ApiClient.new.build_client!(faraday: custom_faraday)
  end

  describe 'requests to tenants endpoint' do
    it 'resets a tenant database' do
      http = nil
      res = @client.v1.admin.create!(tenant_account_id: 'testuser_123') do |response|
        http = response
      end
      assert_equal 200, http.status
      assert res.is_a?(Hash)

      http = nil
      res = @client.v1.admin.reset!(tenant_account_id: 'testuser_123') do |response|
        http = response
      end
      assert_equal 200, http.status
      assert res.is_a?(Hash)
      assert_equal %w[api db health].sort, res.keys.sort
      assert_equal 'success', res['health']
      assert_equal 'V1', res['api']
      assert_equal %w[sequel_constraint_validations schema_info bookings audit_logs lockings].sort,
                   res['db'].sort
    end

    it 'paginates over tenant databases' do
      http = nil
      res = @client.v1.admin.create!(tenant_account_id: 'testuser_123') do |response|
        http = response
      end
      assert_equal 200, http.status
      assert res.is_a?(Hash)

      http = nil
      res = @client.v1.admin.create!(tenant_account_id: 'testuser_124') do |response|
        http = response
      end
      assert_equal 200, http.status
      assert res.is_a?(Hash)

      http = nil
      res = @client.v1.admin.create!(tenant_account_id: 'testuser_125') do |response|
        http = response
      end
      assert_equal 200, http.status
      assert res.is_a?(Hash)

      http = nil
      res = @client.v1.tenants.all(page: 1) do |response|
        http = response
      end
      assert_equal 200, http.status

      assert_equal %w[current_page
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
                      prev_page], res.keys.sort

      assert res['items'].is_a?(Array)
      assert_equal %w[active
                      context
                      created_at
                      current_state
                      id
                      next_state
                      tenant_db_id
                      updated_at],
                   res['items'][0].keys.sort

      assert_equal 1, res['page_count']
      assert_equal 1, res['current_page']
      assert_equal 3, res['pagination_record_count']
      assert_equal 3, res['current_page_record_count']
      assert_equal '1..1', res['page_range']
      assert_equal '1..3', res['current_page_record_range']
      assert res['first_page']
      assert res['last_page']
      assert_nil res['next_page']
      assert_nil res['prev_page']
    end
  end
end
