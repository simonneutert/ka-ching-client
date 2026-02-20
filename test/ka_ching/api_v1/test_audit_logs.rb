# frozen_string_literal: true

require 'test_helper'

describe 'KaChing::ApiV1::AuditLogs', :vcr do
  before do
    @client = KaChing::ApiClient.new.build_client!
    VCR.insert_cassette name
  end

  after do
    VCR.eject_cassette
  end

  describe 'requests to auditlogs endpoint' do
    it 'gets results for auditlogs' do
      audit_logs = @client.v1
                          .audit_logs
                          .of_year(tenant_account_id: 'testuser_1',
                                   year: 2023)

      assert_equal 1, audit_logs.count
      audit_log = audit_logs.first

      assert_equal 1, audit_log['id']
      assert_equal 'lockings', audit_log['table_referenced']

      environment_snapshot = audit_log['environment_snapshot']

      assert_kind_of Hash, environment_snapshot
      assert_kind_of Array, environment_snapshot['bookings']
      assert_kind_of Hash, environment_snapshot['bookings'].first
      assert_kind_of Hash, environment_snapshot['context']
      assert_empty(
        %w[
          action
          amount_cents
          context
          created_at
          id
          realized_at
          updated_at
        ].sort - environment_snapshot['bookings'].first.keys.sort
      )

      log_entry = audit_log['log_entry']

      assert_kind_of Hash, log_entry
      assert_kind_of Array, log_entry['bookings']
      assert_kind_of Hash, log_entry['bookings'].first
      assert_empty(
        %w[
          action
          amount_cents
          context
          created_at
          id
          realized_at
          updated_at
        ].sort - log_entry['bookings'].first.keys.sort
      )
      assert_kind_of Hash, log_entry['context']
    end
  end
end
