
# INTRODUCTION

The aim of this gem is to enable an easy way to serialize an object in a Hash object or a JSON data structure using
the attributes name as keys.

This can be useful if you need to work with XSD schemas while using code generators that convert an schema in
ruby objects but still you haven't a way to convert to JSON or any other format.

# INSTALLATION
    gem install hash-serializer

# HOW TO USE

    require 'hash-serializer'

    class User
        attr_accessor :nickname
        attr_accessor :email
        attr_accessor :password

        def initialize(nickname = nil, email = nil, password = nil)
            @nickname = nickname
            @email = email
            @password = password
        end
    end

    u = User.new("juandebravo", "juan at pollinimini dot net", "*******")

    u.serialize_to_hash
        => {"nickname"=>"juandebravo", "email"=>"juan at pollinimini dot net", "password"=>"*******"}

    u.serialize_to_hash(u.nickname)
        => {"juandebravo"=>{"nickname"=>"juandebravo", "email"=>"juan at pollinimini dot net", "password"=>"*******"}}

    puts u.serialize_to_json
        => {"nickname":"juandebravo","email":"juan at pollinimini dot net","password":"*******"}

    puts u.serialize_to_json("user")
        => {"user":{"nickname":"juandebravo","email":"juan at pollinimini dot net","password":"*******"}}

