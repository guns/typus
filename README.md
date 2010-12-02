# Typus: Admin interface for Rails applications

**Typus** is designed for a single activity:

    Trusted users editing structured content.

**Typus** doesn't try to be all the things to all the people but it's
extensible enough to match lots of use cases.

## Key Features

- Built-in Authentication.
- User Permissions by using Access Control Lists. (stored in yaml files)
- CRUD and custom actions for your models on a clean interface.
- Internationalized interface.
- Customizable and extensible templates.
- Low memory footprint.
- Works with Rails 3.0 and is Ruby 1.9.2 compatible.
- Tested with SQLite, MySQL and PostgreSQL.
- MIT License, the same as Rails.

## Links

- [Documentation](http://core.typuscms.com/)
- [Demo](http://demo.typuscms.com/)
- [Source Code](http://github.com/fesplugas/typus)
- [Mailing List](http://groups.google.com/group/typus)
- [Gems](http://rubygems.org/gems/typus)
- [Contributors List](http://github.com/fesplugas/typus/contributors)

## Installing

Add **Typus** to your `Gemfile`:

    gem 'typus', :git => 'https://github.com/fesplugas/typus.git'

Update your bundle:

    $ bundle install

Run the *Typus* generator:

    $ rails generate typus

Start the application server and go to <http://0.0.0.0:3000/admin>.

## License

Copyright © 2007-2010 Francesc Esplugas, released under the MIT license.
