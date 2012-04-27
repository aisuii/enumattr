# Enumattr

* manage constants by enum like object
* simplify [SelectableAttr](https://github.com/akm/selectable_attr)

## Installation

Add this line to your application's Gemfile:

    gem 'enumattr'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install enumattr

## Usage

### defining

* `include Enumattr::Base` and declare `enum_attr_for some_attribute do ... end`
* `enum :symbol, value` in block

    class User
      include Enumattr::Base

      attr_accessor :status

      enum_attr_for :status do
        enum :active,  1
        enum :suspend, 2
        enum :deleted, 3
      end

      def initialize(status)
        @status = status
      end
    end

### defined methods

#### class methods

* `SomeClass.#{some_attribute}_enums` return enum set
* `SomeClass.#{some_attribute}_keys` return key set
* `SomeClass.#{some_attribute}_values` return value set

    User.status_enums
    #=> #<Set: {#<Enumattr::Enum:0x8a8d13c @key=:active, @value=1>, #<Enumattr::Enum:0x8a8d100 @key=:suspend, @value=2>, #<Enumattr::Enum:0x8a8d0ec @key=:deleted, @value=3>}>

    User.status_keys
    #=> #<Set: {:active, :suspend, :deleted}>

    User.status_values
    #=> #<Set: {1, 2, 3}>

* `SomeClass.#{some_attribute}_enum_by_key(:symbol)` return an enum
* `SomeClass.#{some_attribute}_value_by_key(:symbol)` return a value

    User.status_enum_by_key :active
    #=> #<Enumattr::Enum:0x8a8d13c @key=:active, @value=1>

    User.status_enum_by_key :suspend
    #=> #<Enumattr::Enum:0x8a8d100 @key=:suspend, @value=2>

    User.status_enum_by_key :dummy
    #=> nil

    User.status_value_by_key :active
    #=> 1

    User.status_value_by_key :suspend
    #=> 2

    User.status_value_by_key :dummy
    #=> nil

#### instance methods

* alias `#{some_attribute}_value` `some_attribute`
* `#{some_attribute}_key` return symbol
* `#{some_attribute}_enum` return enum

    user = User.new(1)
    #=> #<User:0x8e17dac @status=1>

    user.status
    #=> 1

    user.status_value # alias
    #=> 1

    user.status_key
    #=> :active

    user.status_enum
    #=> #<Enumattr::Enum:0x8de2e68 @key=:active, @value=1>

* define query method
* `#{some_attribute}_#{some_symbol}?` return bool

    user.status_active?
    #=> true

    user.status_suspend?
    #=> false

    user.status_deleted?
    #=> false

    user.status_dummy?
    NoMethodError: undefined method `status_dummy?' for #<User:0x8e17dac @status=1>

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
