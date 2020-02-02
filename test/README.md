# Test

To test using the local version / code use:

    $ ruby script/pluto.rb help


Example - List all installed planet templates

    $ ruby script/pluto.rb --verbose list


Example - Setup and/or update feed database

    $ ruby script/pluto.rb --verbose update ruby.ini


Example - All-in-One - Setup and/or update and build

    $ ruby script/pluto.rb --verbose build ruby.ini -o o


Example - Merge planet templates

    $ ruby script/pluto.rb --verbose merge ruby.ini -o o

