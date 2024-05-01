class SampleClass
    private # private access
    $global = 1 #global 
    local = 0 #local
    Constant = 0 # constant
    @instance_val = 1 # instance variable
    @@class_val = 1 # class variable
  
    # 変数には@をつけるが、attr_accessorには@をつけない
    attr_accessor :length
    def initialize length
      @length = length
    end
  
    public # public access
    # self.methodでクラスメソッド
    self.class_method 
      puts "class method"
    end
  end
  
  # クラス
# メソッドに感嘆符をつけるのは二通りの慣習がある。
# 1. 破壊的なメソッド
# 2. 処理に失敗した際に例外を発生させるメソッド（！がないものはfalseを返す）

# class定義内で、class << self; endでくくると、クラスメソッドがまとめて定義できる。
# << は、特異クラスの定義のためのもの。クラスメソッドは、クラスの特異メソッドなため。
class ClassName
    def class << self
      def class_method
      end
    end
  end
  
# メソッドのオーバーライド
# superは、引数が与えられている場合、自動で引き継ぐ。
# 引数を引き継がないようにするには、super()と明示的な()がいる

# 特異メソッド
# オブジェクトは、クラスに定義されたメソッドの他に、
# そのオブジェクトに固有のメソッドを持つことができる。
# これを、特異メソッドと呼ぶ。
# 特異メソッドは、オブジェクト.メソッド名の形で記述する。
# 既存のメソッドを、特異メソッドでオーバーライドすることも可能
class AClass
    def a_method
      puts "instance_method"
    end
  end
  obj = AClass.new
  def obj.a_method
    puts "overwritten by singleton method"
  end
  obj.a_method
  
# すでに定義されているクラスの内部クラスを定義するには、
# My::Newclassみたいに::をつけて定義する。

# ネストしたクラスモジュール内で定数を参照した際には、ネストが低い位置の定数が探索される。
# ただし、namespaceをまとめてしまうと参照されない。
VALUE = 'toplevel'
class Foo
  VALUE = 'in Foo class'
  class Bar
    def self.value
      VALUE
    end
    
    def self.topvalue
      ::VALUE # toplevelの参照は、::から始めれば可能
    end
  end
end
Foo::Bar.value # => in Foo class
Foo::Bar.topvalue # => toplevel

class Foo::Baz
    def self.value
      VALUE
    end
  end
  Foo::Baz.value #=> toplevel
  
  # モジュール
# モジュールは、インスタンスの生成と継承ができない
# モジュールの用途として主なものは以下
# 1. 名前空間を作る
# 2. モジュールのメソッドをクラスのインスタンスメソッドとして取り込む
# 3. モジュールのメソッドをクラスの特異メソッド（クラスメソッド）として取り込む
# 4. モジュール関数を定義して使う

# メソッドをクラスのインスタンスメソッドとして取り込むには、includeキーワードを用いる。
# モジュールのメソッド内のselfはクラスのインスタンスを返す。継承もできる。
module Greetable
    def greet_to(name)
      puts "Hello, #{name}, My name is #{self.class}." # includeした場合、selfにはclassのインスタンスが入る
    end
  end
  class Alice
    include Greetable
    def greet_to(name)
      super
      puts "override."
    end
  end
  alice = Alice.new
  alice.greet_to 'Bob'
  
  # extendキーワードを使うと、モジュールに定義されたメソッドはオブジェクトの特異メソッドにできる。
  # したがって、class定義でextendしてモジュールを取り込むと、モジュールのメソッドをクラスメソッドとできる。
  
  # モジュール関数: モジュールのprivateなインスタンスメソッドであると同時に、モジュールの特異メソッドでもあるメソッドのこと。
  # オブジェクトの状態によらず、関数的に呼び出せる
  # モジュール関数は、Module.methodの形で呼び出せるようになる。
  # class内でincludeすれば呼べるが、privateメソッドなので、インスタンスかしたオブジェクトからはcallできない
  # module_functionキーワード(privateキーワードのような扱いなので、endがいらない)をmoduleの定義の中に入れ込むと、モジュール関数にできる
  module AModule
    module_function
      def a_function
        puts "can be called only from a class."
      end
   end
   class AClass
     include AModule
     def call_mod_func
       AModule.a_function
       a_function
     end
   end
   AModule.a_function # モジュールから直接呼べる
   a = AClass.new
   a.call_mod_func # includeしたclassのprivateメソッドとして呼べる
   a.a_function #外からは呼べない
  
   6-1 Classクラスからクラスを作る
   クラスの定義式であるclass AClass endは、
   AClassという定数にClassクラスのインスタンスを割り当てるという意味
   なので、Class.newを使って定義可能。
   定数の代わりに変数に代入すると、Class#nameがnilの無名クラスが出る。
   Class.newで定義する場合、外側のスコープを参照できるメリットがある。
     # 左辺がクラス名。引数は、継承するクラス。ブロックの引数にはselfと等価
     AClass = Class.new(String) do |class_self|  
       def hello
         :hello
       end
     end
   
   6-2 クラスオブジェクト
   6-2-2 インスタンス変数
   クラスもインスタンス変数を持つことができ、クラスインスタンス変数と呼ばれる。
   クラスインスタンス変数と、クラス変数（@@から始まるやつ）との違いは、そのスコープにある。
   まず、クラスのインスタンスからはクラスインスタンス変数は参照できない（リフレクションを使わない限り）
   次に、クラス変数が継承されたクラスとも共用であるのに対し、クラスインスタンス変数は、そのクラスにしか紐付かない。
   クラス全体で共通で持っておきたいものはクラス変数、
   自分のクラスに閉じておきたいものはクラスインスタンス変数という形で使い分ける
     class Test
       # インスタンスメソッド定義(def ... end)以外で定義したインスタンス変数はクラスインスタンス変数
       @class_instance_val = 0
       @@class_val = 0 #クラス変数
       
       def self.class_instance_val
         @class_instance_val #クラスメソッドのselfはクラス自身のため参照できる
       end
       
       def self.class_instance_countup
         @class_instance_val += 1 if @class_instance_val #if文は継承したクラスではnilなため
       end
   
       def self.class_val
         @@class_val
       end
       
       def initialize
         self.class.class_instance_countup #クラス変数から出ないとアクセスできない
         @@class_val += 1
       end
     end
     
     class InheritedTest < Test
     end
     
     5.times { Test.new }
     5.times { InheritedTest.new}
     Test.class_val # Testクラスは５回しかインスタンスされてないのに10が出る
     InheritedTest.class_val # InheritedTestクラスは５回しかインスタンスされてないのに10が出る
     Test.class_instance_val # インスタンス変数なので、Testクラスの回数が出る
     InheritedTest.class_instance_val # 定義していないのでnil
   
   
   6-2-3 クラスメソッド
   クラスメソッドは、クラスオブジェクトの特異メソッド
   
   6-2-4 メソッドの定義
   Module#define_methodを使うと定義できる。
   第一引数にはメソッド名を文字列かSymbol
   第二引数はメソッドの内容をProcオブジェクトか、Method/Unbound Methodオブジェクトとする。
     class KClass
       define_method :a_method, -> { puts :a_method}
     end
   
   6-3 特異クラス
   特異メソッドは、オブジェクトに固有なメソッド。
   その特異メソッドを定義した際にメソッドが定義されるクラスを特異クラスという
   メタクラスと呼ばれることもある。
   特異クラスは、もとのオブジェクトのサブクラス。
   じゃあ何が違うのっていうと、特異クラスのインスタンスであることを無視できる点が異なるっぽい
   あとは、特異クラスからオブジェクトの作成やサブクラスは作れないとのこと。
     obj = Object.new
     class << obj; end
     obj.singleton_class
     obj.instance_of? obj.singleton_class #false
     obj.instance_of? Object #true
   
   6-3-7 特異クラスとObject#extend
   extendすると、特異クラスにincludeされる。
     module AModule end
     obj.include AModule
     obj.singleton_class.ancestors #AModuleが継承される
     obj.class.ancestors # AModuleは存在しない
   
   6-3-8 特異クラスとシングルトンオブジェクト
   特異クラスはインスタンスを生成できないため、シングルトンオブジェクトとできる
     SINGLE_OBJ = Object.new #変更しづらく、どこからでも参照できるように定数に代入
     #持たせたい振る舞いを定義
     class << SINGLE_OBJ
       def only_method
         :only_method
       end
     end
   
   6-4 メソッド探索方法
   1. Rubyインタプリタはまず、レシーバーの特異クラスを参照し、メソッドを探す
   2. 特異クラスにメソッドがないと、特異クラスの親クラスを参照して探す
   3. 参照したクラスにメソッドがない場合、親を遡って探す
   4. 一番上のクラスまで遡ってもメソッドがないと、メソッdの探索を辞める
   5. メソッド名とメソッドの引数を引数とし、
      レシーバの特異クラスからmethod_missingが実装されているクラスを探索する
   
   6-5 Module#Prepend
   モジュールをincludeした場合、クラスの親クラスという継承順序になるが、
   prependするとクラスの子クラスという継承順序になるため、
   prependしたクラスにも同じメソッドがあった場合に、モジュールのメソッドの方が優先される。
   これのメリットは、同名のメソッドがあった場合に、superによって呼び出されるメソッドが、
   クラス側のメソッドとなるため、Moduleの変数の初期化をクラスの方で引き受けられる。
     module AModule
       def a_method
         "Hi" + super
       end
     end
     
     class AClass
       prepend AModule
       def a_method
         "Hello"
       end
     end
     
     AClass.new.a_method
     
   
   6-6 Refinements
   2.0.0ではお試しのもの。
   Rubyは、オープンクラスと言って、組み込みのクラスであっても
   自分のメソッドを再定義できる。
   これは、便利だが、影響が計り知れない。
   そのため、Refinementsは影響範囲を指定できる。
   これは、別途検索した方がよいかも。
   基本的に下記のような構文。
     refine クラス名 do 
       def 新しいメソッド
       end
     end
   
   
   7-1 オープンクラス
   飛ばす。
   
   7-2 method_missing
     BasicObjectに定義されている。
     オーバーライドできるよ、とか。
     飛ばす。
   