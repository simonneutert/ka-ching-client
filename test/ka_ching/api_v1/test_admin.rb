# frozen_string_literal: true

require 'test_helper'

describe 'KaChing::ApiV1::Admin' do
  before do
    @client = KaChing::ApiClient.new.build_client!
    VCR.insert_cassette name
  end

  after do
    VCR.eject_cassette
  end

  describe 'requests to admin endpoint' do
    it 'creates and checks tenant database' do
      http = nil
      res = @client.v1.admin.create!(tenant_account_id: 'testuser_1') do |response|
        http = response
      end
      assert_equal 200, http.status
      assert res.is_a?(Hash)

      http = nil
      res = @client.v1.admin.details(tenant_account_id: 'testuser_1') do |response|
        http = response
      end
      assert_equal 200, http.status
      assert res.is_a?(Hash)
    end

    it 'creates and deletes tenant database' do
      http = nil
      res = @client.v1.admin.create!(tenant_account_id: 'testuser_2') do |response|
        http = response
      end
      assert_equal 200, http.status
      assert res.is_a?(Hash)

      http = nil
      res = @client.v1.admin.drop!(tenant_account_id: 'testuser_2') do |response|
        http = response
      end
      assert_equal 200, http.status
      assert res.is_a?(Hash)
    end
  end
end
