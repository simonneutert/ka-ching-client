# frozen_string_literal: true

require 'test_helper'

describe 'KaChing::ApiV1::Saldo', :vcr do
  before do
    @client = KaChing::ApiClient.new.build_client!
    VCR.insert_cassette name
  end

  after do
    VCR.eject_cassette
  end

  describe 'requests to saldo endpoint' do
    it 'gets current saldo' do
      http = nil
      res = @client.v1.saldo.current(tenant_account_id: 'testuser_1') do |response|
        http = response
      end
      assert_equal 200, http.status
      assert res.is_a?(Hash)

      assert_equal ['saldo'], res.keys
      assert 10_000, res['saldo']
      assert res['saldo'].is_a?(Integer)
    end
  end
end
