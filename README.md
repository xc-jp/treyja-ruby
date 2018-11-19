# Treyja

Treyja is a Ruby script which takes `Tensors` protobin and outputs in human readable way.

## Setup

Setup ruby in your favorite way and make `bundler` available.

With `nix-env`, you can install ruby-2.5.x by:

```
$ nix-env -i $(nix-env -qa | grep ruby-2.5)
```

And install `bundler`:

```
$ gem install bundler
```

Then install depending gems (ruby libraries):

```
$ cd tools/treyja
$ bundle
```

## How to use

Assume that we are in the root dir of `alderaan`.

### To show in JSON format

```
$ draupnir get-local draupnir/test/fixtures/configuration/literal.yaml | tools/treyja/bin/treyja json
{"tensors":[{"dims":[3,2],"dataType":"FLOAT","int32Data":[],"int64Data":[],"uint32Data":[],"uint64Data":[],"floatData":[0.2,0.30000001,1,2,3,5],"doubleData":[]}]}
{"tensors":[{"dims":[3,2],"dataType":"FLOAT","int32Data":[],"int64Data":[],"uint32Data":[],"uint64Data":[],"floatData":[0,0,0.5,0.60000002,0.69999999,0.80000001],"doubleData":[]}]}
```

#### Using jq (optional)

[jq](https://stedolan.github.io/jq/) command is handy to pretty print JSON.

```
$ draupnir get-local draupnir/test/fixtures/configuration/literal.yaml | tools/treyja/bin/treyja json | jq
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

```
$ draupnir get mnist --take 100 | tools/treyja/bin/treyja image --output tmp/mnist-images
```

![mnits-0](https://user-images.githubusercontent.com/1730718/48336250-3b13a100-e6a3-11e8-9f39-558ab792ac01.png)
![mnist-1](https://user-images.githubusercontent.com/1730718/48352360-df134180-e6cf-11e8-8de0-7d083315a55d.png)
![mnist-2](https://user-images.githubusercontent.com/1730718/48352418-f8b48900-e6cf-11e8-8bf5-0714c152911c.png)
![mnist-3](https://user-images.githubusercontent.com/1730718/48352488-21d51980-e6d0-11e8-9af7-907441dfe540.png)
