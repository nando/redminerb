[travis]: https://travis-ci.org/nando/redminerb

# Redminerb

[![Build Status](https://travis-ci.org/nando/redminerb.svg?branch=master)][travis]

Redminerb is a command-line suite that speaks with our Redmine through its REST API.

It's based on the code and ideas present in Restminer[0]. Gracias Carlos!!!

:hand: CAUTION :hand:

Work in progress with RDD[1]: README > Spec > Implementation

[0] http://github.com/theist/restminer

[1] http://tom.preston-werner.com/2010/08/23/readme-driven-development.html

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'redminerb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install redminerb

## Usage

The URL of your Redmine server and your API key needs to be in your
`~/.redminerb.yml` in order to connect to its REST API. For example:

    url: http://localhost:3000/
    api_key: 69b47d74e36a6757bac5d45f8398dd23bfa8f52c

### Configuration (config)

To see the current configuration used by Redminerb we have the `config` command:

    $ redminerb config
    URL:     http://localhost:3000/
    API-KEY: 69b47d74e36a6757bac5d45f8398dd23bfa8f52c

*NOTICE: soon will be possible to specify this values using env. vars and this
command will have more sense.*

### Users

    $ redminerb users # a.k.a. redminerb users list

That should give you the current users on your Redmine server, one per line.

**IMPORTANT: Our API key needs to have the right permissions in the server.**

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nando/redminerb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

