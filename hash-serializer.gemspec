# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require "hash-serializer/version"

Gem::Specification.new do |s|
  s.name        = "hash-serializer"
  s.version     = HashSerializer::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Juan de Bravo"]
  s.email       = ["juandebravo@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{This gem provides an easy way to wrap a class attributes in a key-value representation (Hash object in ruby)}
  s.description = <<END
    Some months ago I worked in a project that defined the data serialization using a XSD schema. I used soap4r gem to create
    ruby objects from the XSD schema, but later I needed to serialize the object value in JSON format. So I defined this
    this extension that enables an easy way to encode an object attributes in Hash and in JSON format.
END

  s.rubyforge_project = "hash-serializer"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency("json_pure", ">= 1.4.3")
end
