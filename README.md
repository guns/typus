# Typus: Admin Panel for Ruby on Rails applications

**Typus** is designed for a single activity:

    Trusted users editing structured content.

**Typus** doesn't try to be all the things to all the people but it's
extensible enough to match lots of use cases.

## Key Features

- Built-in Authentication.
- User Permissions by using Access Control Lists. (stored in yaml files)
- CRUD and custom actions for your models on a clean interface.
- Internationalized interface (Català, German, Greek, English, Español,
Français, Magyar, Italiano, Portuguese, Russian, 中文)
- Customizable and extensible templates.
- Integrated [paperclip][1] and [dragonfly][2] attachments viewer.
- Low memory footprint.
- Works with `Rails 3.0`.
- Tested with `Ruby 1.8.7-p300` and `Ruby 1.9.2-p136`.
- Tested with SQLite, MySQL and PostgreSQL.
- MIT License, the same as Rails.

## Links

- [Documentation](http://core.typuscms.com/)
- [Demo](http://demo.typuscms.com/) ([Code][3])
- [Source Code](http://github.com/fesplugas/typus)
- [Mailing List](http://groups.google.com/group/typus)
- [Gems](http://rubygems.org/gems/typus)
- [Contributors List](http://github.com/fesplugas/typus/contributors)
- [Continous Integration](http://ci.typuscms.com/)

## Installing

Add **Typus** to your `Gemfile`

    gem 'typus', :git => 'https://github.com/fesplugas/typus.git'

Update your bundle

    $ bundle install

Run the generator

    $ rails generate typus

Start the application server

    $ rails server

and go to <http://0.0.0.0:3000/admin>.

## License

Copyright © 2007-2011 Francesc Esplugas, released under the MIT license.

[1]: http://rubygems.org/gems/paperclip
[2]: http://rubygems.org/gems/dragonfly
[3]: https://github.com/fesplugas/typus/tree/master/test/fixtures/rails_app
