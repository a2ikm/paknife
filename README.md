# Paknife

Run knife-solo in parallel.

    $ paknife [<options>] <backend> <subcommand> <nodes> [<knife_options>]

## Requirements

- Ruby >= 2.1
- [knife-solo](http://rubygems.org/gems/knife-solo) (or [knife-zero](http://rubygems.org/gems/knife-zero))

## Installation

```ruby
gem 'paknife'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install paknife

## Usage

You can run `knife solo cook` in parallel like:

    $ paknife solo cook node1 node2 node3 node4

By default, it runs `bundle exec knife solo cook node1` and so on in two threads.

paknife may work with knife-zero like below, but isn't well tested yet:

    $ paknife zero cook node1 node2

### Knife's original options

You can pass knife-solo's (or knife-zero's) original options after nodes arguments like:

    $ paknife solo cook node1 node2 -i /path/to/your/pem


### Number of threads

You can specify the number of threads with `--threads VALUE` and `-t VALUE` options like:

    $ paknife --threads 4 solo cook node1 node2 node3 node4

or

    $ paknife --threads max solo cook node1 node2 nod3 node4

where `max` means "the number of nodes".

This feature is also available with `PARAKNIFE_THREADS` environment variable like:

    $ export PARAKNIFE_THREADS=max
    $ paknife solo cook node1 node2 node3 node4

### Knife command

You can specify knife command with `--knife VALUE` and `-k VALUE` options like:

    $ paknife --knife="/path/to/your/knife" solo cook node1 node2

This feature is also available with `PARAKNIFE_KNIFE` environment variable like:

    $ export PARAKNIFE_KNIFE=/path/to/your/knife
    $ paknife solo cook node1 node2

## Contributing

1. Fork it ( https://github.com/a2ikm/paknife/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
