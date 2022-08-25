# ClassLink Ruby Client

This is a simple client library for the ClassLink OneRoster API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "classlink_client"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install classlink_client

## Usage

### Authentication

Initialize the client using either the Direct, or Proxy Authentication.

#### Direct

For direct access, pass `endpoint`, `client_id`, and `client_secret`:

```ruby
client = ClassLink::Client.new(
  endpoint: "https://sandbox-vn-v2.oneroster.com",
  client_id: "some_client_id",
  client_secret: "some_client_secret"
)
```

#### Proxy

For proxy access, pass `app_id` and `access_token`:

```ruby
client = ClassLink::Client.new(
  app_id: "some_app_id",
  access_token: "some_access_token"
)
```

The resources described in [`lib/classlink_client/interface.rb`](lib/classlink_client/interface.rb) are available as methods on the client. Call them singular with an ID to fetch an individual resource (`client.student(client_id)`), or plural to fetch the index (`client.students`).

### Lazy loading

Resources are lazy loaded; `client.students` doesn't actually make any API requests, but `client.students.first` will.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cpoms/classlink_client.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
