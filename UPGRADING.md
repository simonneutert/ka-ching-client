# Upgrading ka-ching-client

## 0.4.3 Deprecation Warning!

Ruby v2.7 will be deprecated from v0.5.0 on.  
Ruby v3.0 will be the minimum supported version.

## 0.1.0 to 0.2.0

### Changes

* [#5](https://github.com/simonneutert/ka-ching-client/pull/5) Endpoints for lockings do not support `of_year_month` and `of_year_month_day` anymore. Therefor `active` and `inactive` were added to `Lockings` endpoints.
- [#1](https://github.com/simonneutert/ka-ching-client/pull/1) attribute/column was `realized` and is from now on `realized_at`.
