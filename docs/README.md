# Typus Documentation

To build the site you need `nanoc` and `WikiCreole`:

    $ gem install nanoc WikiCreole --no-ri --no-rdoc

## Publishing the site (only for mantainers)

To build the site and deploy it run the following command.

    $ nanoc co && rake deploy:rsync

Copyright © 2007-2011 Francesc Esplugas, released under the MIT license.
