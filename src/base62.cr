require "big"

# Converts between integers/bytes and an alphanumeric encoding.
#
# Default base62 alphabet (`Base62::CHARSET_DEFAULT`) consists of the Arabic
# numerals, followed by the English capital letters and the English lowercase
# letters.
module Base62
  class Error < Exception; end

  # Default character set (`[0-9A-Za-z]`).
  CHARSET_DEFAULT = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

  # Inverted character set (`[0-9a-zA-Z]`).
  CHARSET_INVERTED = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

  extend self

  # Checks whether a *string* is base62-compatible.
  #
  # ```
  # Base62.compatible?("15Ew2nYeRDscBipuJicYjl970D1") # => true
  # ```
  def compatible?(string : String, charset = CHARSET_DEFAULT) : Bool
    string.each_char.all?(&.in?(charset))
  end

  # Returns the base62-decoded version of *string* as a `BigInt`.
  #
  # ```
  # Base62.decode("0000000000000000000001LY7VK") # => 1234567890
  # ```
  def decode(string : String, charset = CHARSET_DEFAULT) : BigInt
    result = BigInt.zero
    base = charset.size

    string.each_char do |char|
      unless digit = charset.index(char)
        raise Error.new("Unexpected character: #{char.inspect}")
      end
      result = result * base + digit
    end
    result
  end

  # Returns the base62-encoded version of *number* as a `String`.
  #
  # ```
  # Base62.encode(1_234_567_890) # => "1LY7VK"
  # ```
  def encode(number : Int, charset = CHARSET_DEFAULT) : String
    return charset[0].to_s if number.zero?

    base = charset.size
    str = String.build do |io|
      while number > 0
        number, remainder = number.divmod(base)
        io << charset[remainder]
      end
    end
    str.reverse
  end

  # Returns the base62-encoded version of *value* as a `String`.
  #
  # ```
  # Base62.encode("\xFF" * 4)           # => "4gfFC3"
  # Base62.encode(Bytes.new(4, 255_u8)) # => "4gfFC3"
  # ```
  def encode(value : String | Bytes, charset = CHARSET_DEFAULT) : String
    value = value.to_slice if value.is_a?(String)
    value = value.to_a
      .map(&.to_s(2).rjust(8, '0'))
      .join
      .to_big_i(2)
    encode(value, charset)
  end
end
