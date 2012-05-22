# Enumattr

* 定数値とキーワードをマッピングすることができます
* クラスはそのマッピングを知っています
* インスタンスは自身の属性値から、マッピングされたキーワードを知ることができます

## 導入

bundler を利用しているなら、Gemfile に以下の行を加え、

    gem 'enumattr'

以下のコマンドを実行します。

    $ bundle

あるいは自身でインストールすることもできます。

    $ gem install enumattr

## 使い方

### 基本

1. `include Enumattr::Base`
2. `enumattr :attr_name do ... end` を宣言
3. `enum :keyword, value` を `do ... end` ブロックのなかで記述

例:

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

すると、クラスメソッドとインスタンスメソッドが定義されます。

* クラスメソッド
  * `User.status_keys` (`{attr_name}_keys`) は、キーワードの配列を返します
  * `User.status_values` (`{attr_name}_values`) は、値の配列を返します
  * `User.status_enums` (`{attr_name}_enums`) は Enum オブジェクトの配列を返します
  * `User.status_enum(:active)` (`{attr_name}_enum(:keyword)`) は、`:keyword` に対応する Enum オブジェクトを返します
  * `User.status_value(:active)` (`{attr_name}_value(:keyword)`) は、`:keyword` に対応する値を返します
* インスタンスメソッド
  * `User#status_key` (`{attr_name}_key`) はマッピングに対応するキーワードを返します
  * `User#status_enum` (`{attr_name}_enum`) はマッピングに対応する Enum オブジェクトを返します
  * `User#status_value` (`{attr_name}_value`) は値を返します (`alias status_value status` とほぼ同義です)
  * `User#status_key = :inactive` (`{attr_name}_key=`) というキーワードによるセッターが定義されます
  * `User#status_active?` (`{attr_name}_{keyword}?`) という、オブジェクトに尋ねるメソッドが定義されます

_Enum オブジェクト_ (`Enumattr::Enums::Enum`) は、`key` と `value` という属性を持ったオブジェクトです。

例:

    User.status_keys
    #=> [:active, :inactive, :deleted]

    User.status_values
    #=> [1, 2, 3]

    User.status_enums
    #=> [#<Enumattr::Enums::Enum:0x9459d00, @key=:active, @value=1, @extras=[]>, #<Enumattr::Enums::Enum:0x9459c88, @key=:inactive, @value=2, @extras=[]>, #<Enumattr::Enums::Enum:0x9459be8, @key=:deleted, @value=3, @extras=[]>]


    enum = User.status_enum(:active)
    #=> #<Enumattr::Enums::Enum:0x007ff58b220618 @container=#<Enumattr::Enums:0x007ff58b2207a8>, @key=:active, @value=1, @extras=[]>

    # Enum オブジェクトは key と value という属性を持っている
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

### オプション

* `:on`
  * enumattr に指定している名前と同じメソッドあるいは属性が存在しない場合に、参照すべきメソッドや属性を指定できます
  * `enumattr :enumattr_name, :on => :existent_attribute do ...`
* `:enums`
  * Hash で enum オブジェクトのマッピングを定義できます。ブロックによる enum オブジェクトの指定の代替記法です
  * Hash で定義した場合、Ruby 1.8.7 以前では配列を返すクラスメソッドで順序が保証されません (`[[:keyword, value1], [:keyword2, value2]]` で代用は可能)
  * `enumattr :enumattr_name, :enums => {:keyword1 => value1, :keyword2 => value2}`
* `:extend`
  * モジュールを指定して enum オブジェクトを拡張することができます
  * `enumattr :enumattr_name, :extend => Extension do ...`

## その他の例

_examples/*.rb_ と _spec/enumattr/*.rb_ を参照してください。

## ご意見・ご指導

ご意見やご指導を歓迎しています！

1. Fork して
2. feature branch を作って (`git checkout -b my-new-feature`)
3. コミットして (`git commit -am 'Added some feature'`)
4. branch を push して (`git push origin my-new-feature`)
5. Pull Request してください
