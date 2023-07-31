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
      assert environment_snapshot.is_a?(Hash)
      assert environment_snapshot['bookings'].is_a?(Array)
      assert environment_snapshot['bookings'].first.is_a?(Hash)
      assert environment_snapshot['context'].is_a?(Hash)
      assert(
        (%w[
          action
          amount_cents
          context
          created_at
          id
          realized_at
          updated_at
        ].sort - environment_snapshot['bookings'].first.keys.sort).empty?
      )

      log_entry = audit_log['log_entry']
      assert log_entry.is_a?(Hash)
      assert log_entry['bookings'].is_a?(Array)
      assert log_entry['bookings'].first.is_a?(Hash)
      assert(
        (%w[
          action
          amount_cents
          context
          created_at
          id
          realized_at
          updated_at
        ].sort - log_entry['bookings'].first.keys.sort
        ).empty?
      )
      assert log_entry['context'].is_a?(Hash)
    end
  end
end
