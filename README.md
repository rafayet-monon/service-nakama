# [Service Nakama](https://rafayet-monon.github.io/service-nakama/)
[![Gem Version](https://badge.fury.io/rb/service-nakama.svg)](https://badge.fury.io/rb/service-nakama)
[![Build Status](https://travis-ci.org/rafayet-monon/service-nakama.svg?branch=master)](https://travis-ci.org/rafayet-monon/service-nakama)
[![Maintainability](https://api.codeclimate.com/v1/badges/5cc27bf49dbb442d24f6/maintainability)](https://codeclimate.com/github/rafayet-monon/service-nakama/maintainability)
[![codecov](https://codecov.io/gh/rafayet-monon/service-nakama/branch/master/graph/badge.svg)](https://codecov.io/gh/rafayet-monon/service-nakama)

This is a tiny gem that provides some basic functionality to Service Objects. Service Object pattern is a popular
 pattern that is used in RoR to maintain thin controllers and models. They are basically just ruby classes that
  encapsulates similar types of functionality for a operation.
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'service-nakama'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install service-nakama

## Usage

To use this gem's functionality, just include the `ServiceNakama` module in your class.

```ruby
class ReportService
  include ServiceNakama
end
```
By default it expects the class to have a instance method named `perform`. This can be changed if needed. This method
 like the main method of the class that will be called when using the service.
 ```ruby
 report = ReportService.perform(some_parameter)
 ```
Using `ServiceNakama` will add two attribute reader to the class. One is `result` and the other one is `error`.

Whatever that is returned from the `perform` method will be considered as the result of the class.
 ```ruby
 report.result
 ```
The error will be in the `error` property of the object.
 ```ruby
 report.error
 ```
It also provides som other handy methods -
 ```ruby
 report.success? # true or false
 report.failed? # true or false
 report.error_message # only error message
 report.error_class # only error class
 ```
Also someone might want to log the error or use some exception tracking service for the errors that occured. To do
 this just have override a instance method `error_logger`
 ```ruby
def error_logger
   Rollbar.error(@error)
end
 ```
If you want something other than `perform` then you do the following -
```ruby
class ReportService
  include ServiceNakama
  main_method :call
end
```
Then it will expect the instance method `call` in that class and can be used like below -
 ```ruby
 report = ReportService.call(some_parameter)
 ```


## Benchmarking
Benchmarking was done using a `ReportService` class for this
[class](https://github.com/rafayet-monon/google-search-extractor/blob/master/app/services/report_service.rb). There
 is on visible performance issue that can done by this gem.
```
                          |  user  |    | system |    |  total   |   |   real     |
-----------------------------------------------------------------------------------
Without ServiceNakama     |5.702399|    |0.017627|    | 5.720026 |   | (5.734128) |
-----------------------------------------------------------------------------------
With ServiceNakama        |5.702157|    |0.007777|    | 5.709934 |   | (5.720078) |
 ```
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rafayet-monon/service-nakama.

