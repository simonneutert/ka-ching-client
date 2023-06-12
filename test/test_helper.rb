# frozen_string_literal: true

require 'pry'

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'ka-ching-client'

require 'minitest/autorun'
require 'vcr'
require 'minitest-vcr'
require 'webmock'

VCR.configure do |c|
  c.cassette_library_dir = 'test/cassettes'
  c.hook_into :faraday
  # c.filter_sensitive_data('<USER>') { ENV['HTTP_AUTH_USER'] }
  # c.filter_sensitive_data('<PASSWORD>') { ENV['HTTP_AUTH_PASSWORD'] }
end

MinitestVcr::Spec.configure!
