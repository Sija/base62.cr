require "./spec_helper"

describe Base62 do
  describe ".decode" do
    it "decodes base 62 numbers that may or may not be zero-padded" do
      %w[awesomesauce 00000000awesomesauce].each do |encoded|
        decoded = Base62.decode(encoded)
        decoded.should eq("1922549000510644890748".to_big_i)
      end
    end

    it "decodes zero" do
      encoded = "0"

      decoded = Base62.decode(encoded)
      decoded.should eq(0)
    end

    it "decodes numbers that are longer than 20 digits" do
      encoded = "01234567890123456789"

      decoded = Base62.decode(encoded)
      decoded.should eq("189310246048642169039429477271925".to_big_i)
    end

    it "raises for words that are not base 62" do
      expect_raises(Base62::Error) { Base62.decode("this should break!") }
    end
  end

  describe ".encode" do
    it "encodes numbers into base 62" do
      number = "1922549000510644890748".to_big_i

      encoded = Base62.encode(number)
      encoded.should eq("awesomesauce")
    end

    it "encodes zero" do
      number = 0

      encoded = Base62.encode(number)
      encoded.should eq("0")
    end

    it "encodes negative numbers as empty string" do
      number = -1

      encoded = Base62.encode(number)
      encoded.should eq("")
    end

    it "encodes byte strings" do
      bytes = "\xFF" * 4

      encoded = Base62.encode(bytes)
      encoded.should eq("4gfFC3")
    end

    it "encodes byte slices" do
      bytes = Bytes.new(4, 255_u8)

      encoded = Base62.encode(bytes)
      encoded.should eq("4gfFC3")
    end
  end

  context "with given IO" do
    it "appends encoded string" do
      number = "1922549000510644890748".to_big_i

      io = IO::Memory.new
      Base62.encode(number, io)
      io.to_s.should eq("awesomesauce")
    end

    it "returns number of bytes written" do
      number = "1922549000510644890748".to_big_i

      io = IO::Memory.new
      count = Base62.encode(number, io)
      count.should eq(12)
    end
  end
end
