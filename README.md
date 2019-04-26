# Treyja

Treyja is a Ruby script which takes `Tensors` protobin and outputs in human readable way.

## Install

Make sure you have `ruby` and `gem` commands installed.

```console
$ ruby --version
ruby 2.5.3p105 (2018-10-18 revision 65156) [x86_64-darwin17]
$ gem --version
2.7.6
```

Using `specific_install` gem, you can install `treyja` gem directly from the directlyGitHub repo.

The following command will do it:

```console
$ gem install specific_install
$ gem specific_install https://github.com/xc-jp/treyja-ruby.git
```

You can check if `treyja` is properly installed by:

```console
% gem list treyja

*** LOCAL GEMS ***

treyja (0.1.0)
```


## How to use

Assume that we are in the root dir of `alderaan` and the path to the project root of treyja-ruby is set to `$TREYJA_RUBY_ROOT`.

### To show in JSON format

```console
$ draupnir get draupnir/test/fixtures/configuration/literal.yaml | $TREYJA_RUBY_ROOT/bin/treyja json
{"tensors":[{"dims":[3,2],"dataType":"FLOAT","int32Data":[],"int64Data":[],"uint32Data":[],"uint64Data":[],"floatData":[0.2,0.30000001,1,2,3,5],"doubleData":[]}]}
{"tensors":[{"dims":[3,2],"dataType":"FLOAT","int32Data":[],"int64Data":[],"uint32Data":[],"uint64Data":[],"floatData":[0,0,0.5,0.60000002,0.69999999,0.80000001],"doubleData":[]}]}
```

#### Using jq (optional)

[jq](https://stedolan.github.io/jq/) command is handy to pretty print JSON.

```console
$ draupnir get draupnir/test/fixtures/configuration/literal.yaml | $TREYJA_RUBY_ROOT/bin/treyja json | jq
{
  "tensors": [
    {
      "dims": [
        3,
        2
      ],
      "dataType": "FLOAT",
      "int32Data": [],
      "int64Data": [],
      "uint32Data": [],
      "uint64Data": [],
      "floatData": [
        0.2,
        0.30000001,
        1,
        2,
        3,
        5
      ],
      "doubleData": []
    }
  ]
}
{
  "tensors": [
    {
      "dims": [
        3,
        2
      ],
      "dataType": "FLOAT",
      "int32Data": [],
      "int64Data": [],
      "uint32Data": [],
      "uint64Data": [],
      "floatData": [
        0,
        0,
        0.5,
        0.60000002,
        0.69999999,
        0.80000001
      ],
      "doubleData": []
    }
  ]
}
```


### To output png image

Output png image files into the directory specified by `--output` option.

Shape of input tensors must be 3 dimensional and channel count must be 1 (grayscale), 2 (grayscale and alpha), 3 (RGB) or 4 (RGB and alpha).

Element type of input tensors must be uint8, int8, float or double.

```console
$ draupnir get mnist --take 100 | $TREYJA_RUBY_ROOT/bin/treyja image --output tmp/mnist-images
```

![mnits-0](https://user-images.githubusercontent.com/1730718/48336250-3b13a100-e6a3-11e8-9f39-558ab792ac01.png)
![mnist-1](https://user-images.githubusercontent.com/1730718/48352360-df134180-e6cf-11e8-8de0-7d083315a55d.png)
![mnist-2](https://user-images.githubusercontent.com/1730718/48352418-f8b48900-e6cf-11e8-8bf5-0714c152911c.png)
![mnist-3](https://user-images.githubusercontent.com/1730718/48352488-21d51980-e6d0-11e8-9af7-907441dfe540.png)


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Setup Ruby

If `rake` or `bundle` failed, you may not have `ruby` installed on your system.

Setup ruby in your favorite way.

With `nix-env`, you can install ruby-2.5.x by:

```console
$ nix-env -i $(nix-env -qa | grep ruby-2.5)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/xc-jp/treyja-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Treyja project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/xc-jp/treyja-ruby/blob/master/CODE_OF_CONDUCT.md).
