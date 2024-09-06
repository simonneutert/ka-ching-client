# frozen_string_literal: true

require 'forwardable'
require 'httpx/adapters/faraday'

require_relative 'ka_ching/version'
require_relative 'ka_ching/api_client'
require_relative 'ka_ching/api_v1/audit_logs'
require_relative 'ka_ching/api_v1/bookings'
require_relative 'ka_ching/api_v1/lockings'
require_relative 'ka_ching/api_v1/saldo'
require_relative 'ka_ching/api_v1/admin'
require_relative 'ka_ching/api_v1/tenants'
require_relative 'ka_ching/api_v1/client'
