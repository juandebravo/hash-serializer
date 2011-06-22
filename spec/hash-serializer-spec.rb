require 'hash-serializer'

describe "hash-serializer" do

  # Generates a method whose return value is memoized after the first call.
  let(:obj) {
    obj = Object.new
    obj.instance_variable_set("@foo".to_sym, "bar")
    obj.instance_variable_set("@bar".to_sym, "bazz")
    obj
  }

  # Generates a method whose return value is memoized after the first call.
  let(:complex_obj) {
    complex_obj = Object.new
    complex_obj.instance_variable_set("@foo".to_sym, "bar")
    complex_obj.instance_variable_set("@bar".to_sym, "bazz")
    complex_obj.instance_variable_set("@bazz".to_sym, obj)
    complex_obj.instance_variable_set("@array".to_sym, [obj, obj])
    complex_obj
  }

  describe "basic object" do

    describe "object to json extension" do
      it "converts properly a basic object with root name" do
        json_obj = HashSerializer.to_json(obj, "object")
        json_obj.should be_a_kind_of(String)
        json_obj = JSON.parse(json_obj)
        json_obj.should be_a_kind_of(Hash)

        json_obj.should have_key("object")
        json_obj = json_obj["object"]
        json_obj.should have_key("foo")
        json_obj.should have_key("bar")
      end


      it "converts properly a basic object without root name" do
        json_obj = HashSerializer.to_json(obj)
        json_obj.should be_a_kind_of(String)
        json_obj = JSON.parse(json_obj)
        json_obj.should be_a_kind_of(Hash)

        json_obj.should have_key("foo")
        json_obj.should have_key("bar")
      end

    end

    describe "object to hash extension" do
      it "converts properly a basic object without root name" do
        json_obj = HashSerializer.to_hash(obj)

        json_obj.should be_a_kind_of(Hash)
        json_obj.should have_key("foo")
        json_obj.should have_key("bar")
      end

      it "converts properly a basic object with root name" do
        json_obj = HashSerializer.to_hash(obj, "foo")
        json_obj.should be_a_kind_of(Hash)
        json_obj.should have_key("foo")

        json_obj = json_obj["foo"]
        json_obj.should have_key("foo")
        json_obj.should have_key("bar")
      end

      it "converts properly a basic object with a symbol as root name" do
        json_obj = HashSerializer.to_hash(obj, :foo)
        json_obj.should be_a_kind_of(Hash)
        json_obj.should have_key(:foo)

        json_obj = json_obj[:foo]
        json_obj.should have_key("foo")
        json_obj.should have_key("bar")
      end
    end
  end

  describe "object with another object as attribute" do

    describe "object to hash extension" do
      it "converts properly a complex object without root name" do

        json_obj = HashSerializer.to_hash(complex_obj)

        ["foo", "bar", "bazz"].each { |key|
          json_obj.should have_key(key)
        }

        bazz = json_obj["bazz"]
        ["foo", "bar"].each { |key|
          bazz.should have_key(key)
        }
      end

      it "converts properly a complex object wit root name" do

        json_obj = HashSerializer.to_hash(complex_obj, :object)

        json_obj.should be_a_kind_of(Hash)
        json_obj.should have_key(:object)
        json_obj = json_obj[:object]

        ["foo", "bar", "bazz"].each { |key|
          json_obj.should have_key(key)
        }

        bazz = json_obj["bazz"]
        ["foo", "bar"].each { |key|
          bazz.should have_key(key)
        }
      end

    end

  end

  describe "object with an array as attribute" do
    describe "object to hash extension" do
      it "converts properly a complex object without root name" do

        json_obj = HashSerializer.to_hash(complex_obj)

        ["foo", "bar", "bazz", "array"].each { |key|
          json_obj.should have_key(key)
        }

        array = json_obj["array"]
        array.length.should be 2
        elem = array[0]
        ["foo", "bar"].each { |key|
          elem.should have_key(key)
        }
      end
    end

    describe "object to json extension" do

      it "converts properly a basic object with root name" do
        json_obj = HashSerializer.to_json(complex_obj)
        json_obj.should be_a_kind_of(String)
        json_obj = JSON.parse(json_obj)
        json_obj.should be_a_kind_of(Hash)
        ["foo", "bar", "bazz", "array"].each { |key|
          json_obj.should have_key(key)
        }
        array = json_obj["array"]
        array.length.should be 2
        elem = array[0]
        ["foo", "bar"].each { |key|
          elem.should have_key(key)
        }
      end
    end

  end

end