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

1. `include Enumattr::Base` and declare `enumattr attribute_name do ... end`
2. `enum :symbol, value` in `do ... end`

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

### defined methods

#### class methods

* `#{attribute_name}_enums` return enum set
* `#{attribute_name}_keys` return  key set
* `#{attribute_name}_values` return value set

example:

    User.status_enums
    #=> #<Set: {#<Enumattr::Enum:0x8a8d13c @key=:active, @value=1>, #<Enumattr::Enum:0x8a8d100 @key=:inactive, @value=2>, #<Enumattr::Enum:0x8a8d0ec @key=:deleted, @value=3>}>

    User.status_keys
    #=> #<Set: {:active, :inactive, :deleted}>

    User.status_values
    #=> #<Set: {1, 2, 3}>

* `#{attribute_name}_enum(key)` return an enum
* `#{attribute_name}_value(key)` return a value

example:

    User.status_enum :active
    #=> #<Enumattr::Enum:0x8a8d13c @key=:active, @value=1>
    
    User.status_enum :inactive
    #=> #<Enumattr::Enum:0x8a8d100 @key=:inactive, @value=2>
    
    User.status_enum :dummy
    #=> nil
    
    User.status_value :active
    #=> 1
    
    User.status_value :inactive
    #=> 2
    
    User.status_value :dummy
    #=> nil

#### instance methods

* getters
  * alias `#{attribute_name}_value` `attribute_name`
  * `#{attribute_name}_key` return symbol
  * `#{attribute_name}_enum` return enum
* setter (if writable)
  * `#{attribute_name}_key=(key)`
  

getters example:

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

setter example:

    user.status_key = :inactive
    #=> :inactive

    user.status
    #=> 2


* Query Method
* `#{attribute_name}_#{key}?` return true or false

example:

    user.status_active?
    #=> false
    
    user.status_inactive?
    #=> true
    
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
