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

if RUBY_DESCRIPTION.match?(/ruby 2\.7\./)
  puts <<~WARNING

    DEPRECATION WARNING!
    KaChingClient will deprecate support for Ruby 2.7 in one of the next minor releases.


  WARNING
  warn 'KaChingClient will deprecate support for Ruby 2.7 in one of the next minor releases.'
  # warn 'KaChingClient does not support Ruby 2.7. Please upgrade to Ruby 3.0 or higher.'
end