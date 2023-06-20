# KaChing::Client<!-- omit from toc -->

KaChing::Client is a Ruby API client for the [KaChing Backend project / simonneutert/ka-ching-backend](https://github.com/simonneutert/ka-ching-backend).

[![Ruby](https://github.com/simonneutert/ka-ching-client/actions/workflows/main.yml/badge.svg)](https://github.com/simonneutert/ka-ching-client/actions/workflows/main.yml)

- [Installation](#installation)
- [Usage (API V1)](#usage-api-v1)
  - [Setup the client](#setup-the-client)
    - [Customize Faraday](#customize-faraday)
  - [Saldo](#saldo)
    - [current](#current)
  - [Bookings](#bookings)
    - [deposit!](#deposit)
    - [withdraw!](#withdraw)
    - [drop!](#drop)
    - [unlocked](#unlocked)
  - [Lockings](#lockings)
    - [lock!](#lock)
    - [unlock!](#unlock)
    - [all paginated](#all-paginated)
    - [of\_year](#of_year)
    - [active](#active)
    - [inactive](#inactive)
  - [AuditLogs](#auditlogs)
    - [of\_year](#of_year-1)
    - [of\_year\_month](#of_year_month)
    - [of\_year\_month\_day](#of_year_month_day)
  - [Tenants](#tenants)
    - [all](#all)
    - [active](#active-1)
    - [inactive](#inactive-1)
  - [Admin](#admin)
    - [details](#details)
    - [create!](#create)
    - [drop!](#drop-1)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add ka-ching-client

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install ka-ching-client

## Usage (API V1)

The KaChing API is a RESTful API. It uses JSON for serialization of requests and responses.

### Setup the client

```ruby
require 'bundle/setup'
require 'ka-ching-client'

client = KaChing::ApiClient.new(api_version: :v1, base_url: 'http://localhost:9292')
                           .build_client!
```

#### Customize Faraday

See the [Faraday documentation](https://lostisland.github.io/faraday/middleware/logger) for more information for the configuration.

```ruby
require 'bundle/setup'
require 'ka-ching-client'

# configure the base url for the client
base_url = 'http://localhost:9292'

# configure the faraday client with a custom logger and your base url
custom_faraday = Faraday.new do |builder|
  builder.url_prefix = base_url
  builder.response :logger, nil, { bodies: { request: true, response: true } }
end

# instantiate the client for the v1 api version and the base url,
# then build the client with the custom faraday client via `build_client!`
client = KaChing::ApiClient.new(api_version: :v1, base_url: base_url)
                           .build_client!(faraday: custom_faraday)
```

### Saldo

All saldo related endpoints.

#### current

Get the current saldo for a tenant.

```ruby
res = client.v1.saldo.current(tenant_account_id: 'testuser_1')
puts res # => { saldo: 100 }
```

### Bookings

All booking related endpoints.

#### deposit!

Books a deposit for a tenant.

```ruby
res = client.v1.bookings.deposit!(
  tenant_account_id: 'testuser_1',
  amount_cents: 100,
  year: 2019,
  month: 11,
  day: 1,
  context: {'foo' => 'bar'}
)
```

#### withdraw!

Books a withdrawal for a tenant.

```ruby
res = client.v1.bookings.withdraw!(
  tenant_account_id: 'testuser_1',
  amount_cents: 100,
  year: 2019,
  month: 11,
  day: 1,
  context: {'foo' => 'bar'}
)
```

#### drop!

Drops/Deletes a booking for a tenant by its id.

```ruby
res = client.v1.bookings.drop!(
  tenant_account_id: 'testuser_1',
  booking_id: 'uuid-example-1234'
)
```

#### unlocked

Shows all unlocked bookings for a tenant.

```ruby
res = client.v1.bookings.unlocked(tenant_account_id: 'testuser_1')
puts res # => [{ id: 'uuid-example-1234', amount_cents: 100, ... }]
```

### Lockings

All lockings related endpoints.

#### lock!

Locks all unlocked bookings for a tenant by its id on (including) the given year-month-day.

```ruby
res = client.v1.lockings.lock!(
  tenant_account_id: 'testuser_1',
  amount_cents_saldo_user_counted: '1000',
  year: 2019,
  month: 11,
  day: 1,
  context: {'foo' => 'bar'}
)
```

#### unlock!

Unlock the last locking for a tenant by its id.

```ruby
res = client.v1.lockings.unlock!(tenant_account_id: 'testuser_1')
```

#### all paginated

Get all lockings for a tenant paginated.

```ruby
res = client.v1.lockings.all(
  tenant_account_id: 'testuser_1',
  page: 1,
  per_page: 10,
)
```

#### of_year

Get lockings for a tenant by year.

```ruby
res = client.v1.lockings.of_year(tenant_account_id: 'testuser_1', year: 2019)
```

#### active

Get active lockings for a tenant for a year.

```ruby
res = client.v1.lockings.active(
  tenant_account_id: 'testuser_1',
  year: 2019,
)
```

#### inactive

Get inactive lockings for a tenant for a year.

```ruby
res = client.v1.lockings.inactive(
  tenant_account_id: 'testuser_1',
  year: 2019,
)
```

### AuditLogs

All audit_logs related endpoints.

#### of_year

Get audit_logs for a tenant by year.

```ruby
res = client.v1.audit_logs.of_year(tenant_account_id: 'testuser_1', year: 2019)
```

#### of_year_month

Get audit_logs for a tenant by year and month.

```ruby
res = client.v1.audit_logs.of_year(
  tenant_account_id: 'testuser_1',
  year: 2019,
  month: 11
)
```

#### of_year_month_day

Get audit_logs for a tenant by year, month and day.

```ruby
res = client.v1.audit_logs.of_year(
  tenant_account_id: 'testuser_1',
  year: 2019,
  month: 11,
  day: 21
)
```

### Tenants

All tenants related endpoints.

#### all

Get all tenants paginated.

```ruby
res = client.v1.tenants.all(page: 1)
```

#### active

Get all active tenants paginated.

```ruby
res = client.v1.tenants.active(page: 1)
```

#### inactive

Get all inactive tenants paginated.

```ruby
res = client.v1.tenants.inactive(page: 1)
```

### Admin

All admin related endpoints, for managing tenant databases.

#### details

Details of a tenant database.

```ruby
res = client.v1.admin.details(tenant_account_id: 'testuser_1')
```

#### create!

Create a new tenant database.

```ruby
res = client.v1.admin.create!(tenant_account_id: 'testuser_1')
```

#### drop!

Drop/Delete a tenant database.

```ruby
res = client.v1.admin.drop!(tenant_account_id: 'testuser_1')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

In order to record new VCR cassettes you need to bring the database into a state where the cassettes can be recorded.

It is recommended to run tests in a certain order one after another. So, you end up with the fresh cassettes you might need.

But as long as `V2` is not released, you can just run the tests in the order they are defined in the test file and use the cassettes already recorded.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/simonneutert/ka-ching-client.

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
