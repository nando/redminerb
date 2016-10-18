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

    $ gem install redminerb

## Usage

    redminerb [COMMAND] [SUBCOMMAND|<id>]

Behind the scenes `redminerb` uses the gem Thor, so calling it without params is the same as asking for help:

    $ redminerb
    Commands:
      redminerb config                # Shows this session current configuration
      redminerb help [COMMAND]        # Describe available commands or one specific command
      redminerb issues [list|<id>]    # Manage Redmine's issues
      redminerb projects [list|<id>]  # Manage Redmine's projects
      redminerb users [list|<id>]     # Manage Redmine's users

In order to use `redminerb` the URL and the API key of your Redmine REST API must be available in one of the following places:

1. **In your environment**: using *REDMINERB_URL* and *REDMINERB_API_KEY* environment variables.
2. **In `~/.redminerb.yml`**: as values of *url* and *api_key* keys.

For example, this `~/.redminerb.yml`:

    url: https://redmine.ruby-lang.org/
    api_key: 69b47d74e36a6757bac5d45f8398dd23bfa8f52c

Would be the same as having the following in your environment (declared in `~/.bashrc`, for example):

    export REDMINERB_URL=https://redmine.ruby-lang.org/
    export REDMINERB_API_KEY=69b47d74e36a6757bac5d45f8398dd23bfa8f52c

If both present **environment variables have priority** (remember that you can remove them from the environment running `unset NAME-OF-VARIABLE`).

As **a general rule**, the `list` subcommand is the one assumed when omitted, but if a number is given then the `show` subcommand will be call using that number as param. For example, `redminerb issues` will show us the **list** of the last issues availables for our user, and `redminerb issue 11962` will **show** us the info of the the issue with id number 11962 (notice that also the singular, *issue* here, can be used as the command, which sounds more natural for this feature -thanks Thor!)

### Configuration (config)

To see the current configuration used by Redminerb run the `config` command:

    $ redminerb config
    URL:     https://redmine.ruby-lang.org/
    API-KEY: 69b47d74e36a6757bac5d45f8398dd23bfa8f52c

### Pagination

Collections of resources will give us the results as indicated by the
[Redmine pagination documentation](http://www.redmine.org/projects/redmine/wiki/Rest_api#Collection-resources-and-pagination) and the *--limit (-l)* and *--offset (-o)* options can be used.

For example, you could see the third user of your Redmine with:

    $ redminerb users list --offset 3 --limit 1

That is the same than asking for:

    $ redminerb users -o 3 -l 1

Because `list` is the default subcommand for the `users` command.

### Custom ERB templates

The output of **a single resource** obtained with **the `show` subcommand can be customized creating the corresponding `.erb` file** in the `.redminerb/templates` directory. The `.redminerb` directory will be searched **first in the current directory and then in your home directory**.

Into the template we access the resource using its generic name (`user`, `issue`, `project`...). The default templates used by *redminerb* and other examples could be found in the *templates* directory of this repository.

For example, to customize the output of an issue, we write the following content in the `.redminerb/templates/issue.erb` file:

    Number: <%= issue.id %>
    Title: <%= issue.subject %>

We can also create a template to be used only when asked through **the `--template` option**. For example:

    $ redminerb user show 34 --template user_in_a_box

Will use the file `.redminerb/templates/user_in_a_box.erb` as template, whose content could be the following:

    <%= Redminerb.top %>
    <%= Redminerb.line user.login %>
    <%= Redminerb.bottom %>

...which will give us an output similar to this:

    ┌────────────────────────────────────┐
    │ roger.williams                     │
    └────────────────────────────────────┘

As you can see Redminerb give us also **some functions to draw** its output using old-school boxes. These functions are:

* **Redminerb.top**: shows the top of the box (i.e. `┌──────┐`).
* **Redminerb.middle**: shows a line in the middle of the box (i.e. `├──────┤`).
* **Redminerb.bottom**: shows the bottom of the box (i.e. `└──────┘`).
* **Redminerb.line** *string*: content into the box (i.e. `│ Example │`).
* **Redminerb.separator**: a line from left to right (like *middle* wo/ box borders).

### Users

The **users** command is the wrapper for part of the [Users resource](http://www.redmine.org/projects/redmine/wiki/Rest_Users) of the Redmine REST API.

**IMPORTANT: This is an admin command so be sure that your API key's user have that permission in the Redmine server. Otherwise a 403 exception will be thrown.**

#### List current users

**List** is the default subcommand of the *users* command:

    $ redminerb users # i.e. 'redminerb users list'

That should give you the current users on your Redmine server, one per line. It will return a 403 error if our API key's user doesn't have permission to list users.

You can use the `--name` option to list users as described by the *name* filter of the API resource (see the link above). The `-q` and `--query` are aliases for this option. For example:

    $ redminerb users -q red # i.e. 'redminerb users list --name=red'

Will show us the **users whose login, first name, last name or email** contains the **'red'** word.

By omission *users list* gives you the ID, the login and the e-mail of the user. You can
change that using the *--fields (-f)* option, that let you specify others separated
by semicolons. For example:
 
    $ redminerb users -f id:mail

Will return only the ID following by the user's email.

You can see **all the fields available** with `redminerb user me`.

**To list all the users at the database** you can use the `--all` option. Internally it will make as many HTTP requests to the REST API as needed. Here the `--limit` option let's manage the maximum number of users it will get with each request (to search, if possible, consider using the `--query` option instead).

#### Show our info in the Redmine server

    $ redminerb user me

Will show the data in the Redmine server associated with the account that has
the API key used to access the Rest API (hopefully your data :).

#### Show user's data

    $ redminerb user [show] <id>

Will give us the info associated with the user with the given *id*.

#### Create new user

To create a new user we should use the *create* subcommand:

    $ redminerb users create

It **will ask for the required params** giving us the possibility to fix any mistake until we confirm that everything is ok.

If want to supply some (or all) of the values when calling `redminerb` we can use the following subcommand options (extracted from `redminerb users help create`):

    -n, --name, [--login=LOGIN]
    -p, --pass, [--password=PASSWORD]
    -f, --fn, [--firstname=FIRSTNAME]
    -l, --ln, [--lastname=LASTNAME]
    -m, --email, [--mail=MAIL]

Use the option **--no-ask** if you're supplying all the required values and don't want to be asked for them (from a script, for example).

### Issues

The **issues** command is the wrapper for part of the [Issues resource](http://www.redmine.org/projects/redmine/wiki/Rest_Issues) of the Redmine REST API.

#### List issues

    $ redminerb issues [list] [--closed|-c] [--project_id|-p <id>] [--assigned_to_id|-a <id>] [--fixed_version_id|-v <id>]

Examples:

    $ # Show the first three issues of the project whose id equals 1:
    $ redminerb issues -p 1 -l 3
    [Systems#148] Poner Pisco en modo sólo lectura
    [Systems#110] [Tatefiel] Añadir tarea de cron
    [Systems#172] SSID para cámaras de seguridad

    $ # Show the issues assigned to the user whose id equals 42:
    $ redminerb issues -a 42
    [Primeroto#166] Se deben mover todas las imágenes al proyecto
    [Primeroto#165] No se pueden escoger los eventos de entradas

#### Show an issue

Shows the info of an issue with a number or id.

    $ redminerb issue [show] <number>

For example, to see the info of the issue #12539 we'd launch:

    $ redminerb issue 12539


### Projects

The **projects** command is the wrapper for part of the [Projects resource](http://www.redmine.org/projects/redmine/wiki/Rest_Projects) of the Redmine REST API.

#### List projects

    $ redminerb projects [list] [-q|--query <FILTER>] [--all]

The command *projects* will give us the ids of every public and private project where the user have access to.

The results can be **filtered** through a **case unsensitive match** using the *--query (-q, --name)* option. For example, the order `redminerb projects -q iber` will show us all projects whose names match **"IBER"**.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nando/redminerb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

