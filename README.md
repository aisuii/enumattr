# Enumattr

* mapping constant value and keyword
* _class_ knows the mapping
* _instance_ knows its attribute value's keyword from the mapping

## Installation

Add this line to your application's Gemfile:

    gem 'enumattr'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install enumattr

## Usage

## Basics

1. `include Enumattr::Base`
2. declare `enumattr :attr_name do ... end`
3. `enum :keyword, value` in `do ... end` block

example:

    class User
      include Enumattr::Base

      attr_accessor :status

      enumattr :status do
        enum :active,   1
        enum :inactive, 2
        enum :deleted,  3
      end

      def initialize(status)
        @status = status
      end
    end

then defining class methods and instance methods.

* class methods
  * `User.status_keys` as `{attr_name}_keys` return keyword set
  * `User.status_values` as `{attr_name}_values` return value set
  * `User.status_enums` as `{attr_name}_enums` return Enum object set
  * `User.status_enum(:active)` as `{attr_name}_enum(:keyword)` return an Enum object
  * `User.status_value(:active)` as `{attr_name}_value(:keyword)` return a value
* instance methods
  * `User#status_key` as `{attr_name}_key` return a keyword correspond to mapping
  * `User#status_enum` as `{attr_name}_enum` return a Enum object correspond to mapping
  * `User#status_value` as `{attr_name}_value` return a value (`alias status_value status`)
  * `User#status_key = :inactive` as `{attr_name}_key=` setter by keyword
  * `User#status_active?` as `{attr_name}_{keyword}?` query method return true or false

_Enum object_ (`Enumattr::Enums::Enum`) has `key` and `value` attributes

example:

    User.status_keys
    #=> #<Set: {:active, :inactive, :deleted}>

    User.status_values
    #=> #<Set: {1, 2, 3}>

    User.status_enums
    #=> #<Set: {#<Enumattr::Enums::Enum:0x007ff58b220618 @container=#<Enumattr::Enums:0x007ff58b2207a8>, #<Enumattr::Enums::Enum:0x007ff58b220488 @container=#<Enumattr::Enums:0x007ff58b2207a8>, @key=:inactive, @value=2, @extras=[]>, #<Enumattr::Enums::Enum:0x007ff58b220488 @container=#<Enumattr::Enums:0x007ff58b2207a8>, @key=:deleted, @value=3, @extras=[]>}>


    enum = User.status_enum(:active)
    #=> #<Enumattr::Enums::Enum:0x007ff58b220618 @container=#<Enumattr::Enums:0x007ff58b2207a8>, @key=:active, @value=1, @extras=[]>

    # Enum object has key and value attributes
    enum.key
    #=> :active

    enum.value
    #=> 1

    User.status_enum(:dummy)
    #=> nil

    User.status_value(:active)
    #=> 1

    User.status_value(:dummy)
    #=> nil


    user = User.new(1)
    #=> #<User:0x007ff58b050dd8 @status=1>

    user.status
    #=> 1

    user.status_key
    #=> :active

    user.status_value
    #=> 1

    user.status_key = :inactive
    #=> :inactive

    user.status
    #=> 2

    user.status_active?
    #=> false

    user.status_inactive?
    #=> true

## More examples

see: _examples/*.rb_ and _spec/enumattr/*.rb_

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
