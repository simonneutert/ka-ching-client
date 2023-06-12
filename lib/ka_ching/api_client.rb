# frozen_string_literal: true

module KaChing
  #
  # The base class for all API versions.
  #
  class ApiClient
    attr_accessor :conn
    attr_reader :api_version, :base_url, :v1

    def initialize(api_version: :v1, base_url: 'http://localhost:9292')
      @api_version = api_version
      @base_url = base_url
    end

    def build_client!(faraday: nil)
      @conn = faraday || default_faraday
      case @api_version
      when :v1, 'v1'
        @v1 = KaChing::ApiV1::Client.new(conn: @conn, base_url: @base_url)
      else
        raise ArgumentError, "Unknown API version: #{@api_version}"
      end
      self
    end

    private

    def default_faraday
      Faraday.new do |builder|
        builder.url_prefix = @base_url
        builder.use Faraday::Request::UrlEncoded
        builder.use Faraday::Response::RaiseError
        builder.use Faraday::Response::Logger

        builder.adapter :httpx
      end
    end
  end
end
