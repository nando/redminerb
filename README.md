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

In order to use `redminerb` the URL and the API key of your Redmine REST API must be available in one of the following places:

1. **In your environment**: using *REDMINERB_URL* and *REDMINERB_API_KEY* env. vars.
2. **In `~/.redminerb.yml`**: as values of *url* and *api_key*.

For example, this `~/.redminerb.yml`:

    url: http://localhost:3000/
    api_key: 69b47d74e36a6757bac5d45f8398dd23bfa8f52c

Would be the same as having the following in your environment (declared in `~/.bashrc`, for example):

    export REDMINERB_URL=http://localhost:3000/
    export REDMINERB_API_KEY=69b47d74e36a6757bac5d45f8398dd23bfa8f52c

If both present **environment variables have priority**.

As a general rule, the `list` subcomand is the one assumed when omitted, but if a number is given instead of a subcomand, then the `show` subcommand will be call using that number as param. For example `redminerb users 1` will show us the info of the first user of our Redmine. Notice that also the singular can be used for the command, which is nice for these cases (i.e. `redminerb user 1`, thanks Thor!)

### Pagination

Collections of resources will give us the results as indicated by the
[Redmine pagination documentation](http://www.redmine.org/projects/redmine/wiki/Rest_api#Collection-resources-and-pagination) and the *--limit (-l)* and *--offset (-o)* options can be used.

For example, you could see the third user of your Redmine with:

    $ redminerb users list --offset 3 --limit 1

That is the same than asking for:

    $ redminerb users -o 3 -l 1

Because `list` is the default subcommand for the `users` command.

### Custom ERB templates

The output of **a single resource** obtained with **the `show` subcommand can be customized creating the corresponding `.erb` file** in the *.redminerb/templates* directory. In the template we can access to the resource using its generic name, e.g. `user` or `issue`.

The default templates could be found in the *templates* directory.

For example, to customize the output of an issue, we write the following content in the `.redminerb/issue.erb` file:

    Number: <%= issue.id %>
    Title: <%= issue.subject %>

The *.redminerb* directory will be search **in the current directory first**, and then in **your home directory**.

We can also create other templates and use them through **the `--template` option**. For example:

    $ redminerb users show 34 --template user_in_a_box

Will use the file `.redminerb/user_in_a_box.erb` as template, whose content could be the following:

    <%= Redminerb.top %>
    <%= Redminerb.line user.login %>
    <%= Redminerb.bottom %>

That would give us an output similar to this:

    ┌────────────────────────────────────┐
    │ roger.williams                     │
    └────────────────────────────────────┘

As you can see Redminerb give us also **some functions to draw** its output using old-school boxes. These functions are:

* **Redminerb.top**: shows the top of the box (i.e. `┌──────┐`).
* **Redminerb.middle**: shows a line in the middle of the box (i.e. `├──────┤`).
* **Redminerb.bottom**: shows the bottom of the box (i.e. `└──────┘`).
* **Redminerb.line** *string*: content into the box (i.e. `│ Example │`).
* **Redminerb.separator**: a line from left to right (like *middle* wo/ box borders).

Have fun with them!

### Configuration (config)

To see the current configuration used by Redminerb we have the `config` command:

    $ redminerb config
    URL:     http://localhost:3000/
    API-KEY: 69b47d74e36a6757bac5d45f8398dd23bfa8f52c

### Users

The **users** command is the wrapper for part of the [Users resource](http://www.redmine.org/projects/redmine/wiki/Rest_Users) of the Redmine REST API.

**IMPORTANT: Be sure that your API key's user have the right permissions in the server.**

#### List current users

**List** is the default subcommand of the *users* command:

    $ redminerb users # i.e. 'redminerb users list'

That should give you the current users on your Redmine server, one per line.

You can use the `--name` option to list users as described by the *name* filter of the API resource. The `-q` and `--query` are aliases for this option. For example:

    $ redminerb users -q red # i.e. 'redminerb users list --name=red'

Will show us the users which login, first name, last name or email contains the 'red' word.

By omission *users list* gives you the ID, the login and the e-mail of the user. You can
change that using the *--fields (-f)* option, that let you specify others separated
by semicolons. For example:
 
    $ redminerb users -f id:mail

Will return only the ID following by the user's email.

You can see **all the fields available** with `redminerb user me`.

#### Show our info in the Redmine server

    $ redminerb user me

Will show the data in the Redmine server associated with the account that has
the API key used to access the Rest API (hopefully your data :).

#### Show user's data

    $ redminerb user [show] <id>

Will give us the info associated with the user with the given *id*.

#### Create new user

To create a new user we should use the *create* subcommand:

    $ redminerb users create --login wadus --password="ultrasecret" \
                             --firstname="Wadux" --lastname Wallace \
                             --mail "wadus@waduxwallace.out"

The options have the following aliases (extracted from `redminerb users help create`):

    l, --login=LOGIN           
    p, --password=PASSWORD     
    fn, --firstname=FIRSTNAME  
    ln, --lastname=LASTNAME    
    m, --mail=MAIL

So, the previous command is the same as the following:

    $ redminerb users create -l wadus -p ultrasecret -fn Wadux -ln Wallace \
                             -m wadus@waduxwallace.out

### Issues

The **issues** command is the wrapper for part of the [Issues resource](http://www.redmine.org/projects/redmine/wiki/Rest_Issues) of the Redmine REST API.

#### List issues

    $ redminerb issues [list]

#### Show an issue

Shows the info of an issue with a number or id.

    $ redminerb issue [show] <number>

For example, to see the info of the issue #12539 we'd launch:

    $ redminerb issue 12539

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nando/redminerb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

