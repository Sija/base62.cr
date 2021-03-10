# Base62.cr [![CI](https://github.com/Sija/base62.cr/actions/workflows/ci.yml/badge.svg)](https://github.com/Sija/base62.cr/actions/workflows/ci.yml) [![Releases](https://img.shields.io/github/release/Sija/base62.cr.svg)](https://github.com/Sija/base62.cr/releases) [![License](https://img.shields.io/github/license/Sija/base62.cr.svg)](https://github.com/Sija/base62.cr/blob/master/LICENSE)

Crystal shard for Base62 encoding/decoding. It's especially useful for
converting data into shortened strings suitable for URL shortening and/or
obfuscating auto-incrementing resource ids from being exposed through RESTful
APIs.

## What is Base62 encoding?

Base62 encoding converts numbers to ASCII strings (0-9, a-z and A-Z) and vice
versa, which typically results in comparatively short strings. Such identifiers
also tend to be more readily identifiable by humans.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  base62:
    github: Sija/base62.cr
```

## Usage

```crystal
require "base62"

Base62.encode(999)  # => "G7"
Base62.decode("G7") # => 999
```

This uses the default **ASCII character set** for encoding/decoding.

It's also possible to define a **custom character set** instead:

```crystal
charset = "~9876543210ABCDEFGHIJKLMNOPQRSTU$#@%!abcdefghijklmnopqrstuvw-="

Base62.encode(999, charset)  # => "F3"
Base62.decode("F3", charset) # => 999
```

Note that `charset` typically expects the respective string to contain
exactly 62 unique character. In fact, it's also possible to use characters
sets with more than 62 characters in order to achieve shorter identifiers
for large numbers.

## Contributing

1. Fork it (<https://github.com/Sija/base62.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [@Sija](https://github.com/Sija) Sijawusz Pur Rahnama - creator, maintainer
