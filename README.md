# Paraknife

Run knife-solo (or knife-zero) in parallel.

    $ paraknife [<options>] <backend> <subcommand> <nodes> [<knife_options>]


## Installation

```ruby
gem 'paraknife'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install paraknife

## Usage

You can run `knife solo cook` in parallel like:

    $ paraknife solo cook node1 node2 node3 node4

By default, it runs `bundle exec knife solo cook node1` and so on in two threads.

### Knife's original options

You can pass knife-solo's (or knife-zero's) original options after nodes arguments like:

    $ paraknife solo cook node1 node2 -i /path/to/your/pem


### Number of threads

You can specify the number of threads with `--threads VALUE` and `-t VALUE` options like:

    $ paraknife --threads 4 solo cook node1 node2 node3 node4

or

    $ paraknife --threads max solo cook node1 node2 nod3 node4

where `max` means "the number of nodes".

This feature is also available with `PARAKNIFE_THREADS` environment variable like:

    $ export PARAKNIFE_THREADS=max
    $ paraknife solo cook node1 node2 node3 node4

### Knife command

You can specify knife command with `--knife VALUE` and `-k VALUE` options like:

    $ paraknife --knife="/path/to/your/knife" solo cook node1 node2

This feature is also available with `PARAKNIFE_KNIFE` environment variable like:

    $ export PARAKNIFE_KNIFE=/path/to/your/knife
    $ paraknife solo cook node1 node2

## Contributing

1. Fork it ( https://github.com/a2ikm/paraknife/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
