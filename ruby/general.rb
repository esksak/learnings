=begin
複数行コメント
aaa
bbb
=end

# ||= 演算子： 変数定義されていない場合のみ、デフォルト値を代入する
"#{alskjreafk ||= book_2 ||= "default"}"

# if notを意味するuntil文がある
until counter > 10
	counter += 1
end

# next: Cにおけるcontinue
# break: loopの終了
# redo: loopをもう一度回す
i = 0
loop do
 	i += 1
 	next if i % 2 == 0
  redo if i == 3
 	print(i, " ")
 	break if i > 5
end

# case分にbreakは必要ない。
# 複数の条件がある場合は","で区切れる
# caseは===の値がtrueになるかで判定され、オブジェクトによって===の性質は異なる
# Range: 引数が自身の範囲内に含まれるなら真
# Regexp: 引数の文字列がマッチした場合に真
# Proc: 右辺を引数にして実行した結果を返す
# Module, Class: 引数が自身又は自身のサブクラスのインスタンスであれば真

# do whileはbegin endでくくることで達成可能
i = 0
begin 
  puts "hello"
  puts "hello2"
  i += 1
end while i < 10

# , による複数オブジェクトの処理
# return val1, val2, val3とすることで、左記の値の配列オブジェクトを返せる
# case cond1, cond2とすることで、複数conditionの条件をかける
# rescue Error1, Error2とすることで複数エラーをrescueできる

# 多重代入
a, b = [1, 2, 3]# 3は無視される。逆に左辺の方が多い場合はnilが入る
a, *b = [1, 2, 3] # a= 1, b = [2, 3]が入る。可変長引数。
# 実引数に*をつけると、配列を複数の引数として展開して渡せる
  
# ==は、大抵の場合同値性を判断するもので、同一性を確認するにはequal?メソッドを使う

# メソッドとして定義されている演算子
# 単項演算子（+237とか、-54とかのこと）の定義は、+@ -@で行う。
# メソッドは大文字から始めても良いが、その場合呼び出しに括弧が必須になる

# キーワード引数
# **をつけた仮引数で、オプションの引数をハッシュで受け取れる
def keywords(alice: nil, bob: nil, **others)
  {alice: alice, bob: bob, others: others}
end
keywords alice: 'aliiice', bob: 'boob', charlie: 'charlie', dave:'dave'
  
# 仮引数の順序は以下の順序で並んでいる必要がある
# 1. 通常の引数・省略可能な（デフォルトがある）引数
# 2. 可変長引数
# 3. キーワード引数
# 4. **で指定できるハッシュの引数
# 5. &で指定できるブロックの引数

# undefを使うことでメソッド定義を取り消せる。組み込みのメソッドすらも取り消せる
undef メソッド名

# aliasで別名を付けられる。undefで本体を消しても、aliasの方は消えない。
alias エイリアス名 メソッド名
  
# %記法
# %q/%Q（もしくは％のみ）: 文字列の生成（小文字はシングルクォート、大文字はダブルクォート）
# %w/%W: 文字列の配列（大文字は#{}が使える）
# %i/%I: シンボルの配列（大文字は#{}が使える）
# %x: コマンド出力（バッククォートと同じ）
# %s: シンボル
# %r: Regexp（/をエスケープする必要がなくなる）

str = %q(it's rainy) #'をエスケープせずに済む
str = %Q("We are rubist!!") #"をエスケープせずに済む
str = %("We are rubist!!") #QはなくてもOK
str_array = %w(alice bob charlie) # => ["alice", "bob", "charlie"]
sym_array = %i(alice bob charlie) # => [:alice, :bob, :charlie]
%x(echo "hoge") # => "hoge\n"
symbol = %s(hogehoge) # => :hogehoge
# %記法の区切り文字は()以外でも良い
str = %Q!exclamation! # 区切り文字を ! に
# Regexp
# /pattern/と書く（もしくは%r）
# パターンマッチは、===（boolを返す）か、=~(マッチした位置を返す)で行う
/b/ === "hisnameisbob" # => true
/b/ =~ "hisnameisbob" # => 9
 "hisnameisbob" === /b/ # => false （Regexが左に来ないといけない）

# 例外：基本的なエラーはStandardErrorを継承している。
# 例外の発生は raise で行う
# 第一引数に文字列を指定すると、例外のメッセージとして、RuntimeErrorを発生させる
# 第一引数に例外オブジェクト、第二引数にメッセージもOK
# rescue節は複数指定できる。同じ処理を違う例外処理で行いたければ","で区切る
# javaで言うfinally節は、ensureという。
# elseは、例外が発生しなかった場合の処理を記述できる
# rescueを後ろから修飾することもできるが、その場合補足できる例外はStandard Errorとそのサブクラスに限られる
# begin, rescue, elseでの戻り値は変数に代入可能。ensureの値は実行されても戻り値とならない。
# retryで、例外が発生した場合にリトライできる。
returned =
  begin
    value = "begin"
    failed ||= 0
    raise
  rescue => e #e は例外オブジェクトが入っている
    e.class
    e.message
    #e.backtrace
    failed += 1
    retry if failed < 5 # begin節の最初から実行される
    value = "rescue failed = #{failed}"
  else
    value = "else"
  ensure # ensureの後ろにelseは持ってこれない。当たり前か。
    "This will never be returned"
  end

beginの代わりに、def class, def modele, def methodでもOK

#大域脱出
catch オブジェクト do 
  throw オブジェクト
end で可能。
throwの第二引数に戻り値を指定できる。

  returned = 
    catch :triple_loop do
      loop do
        puts 'one'
        loop do
          puts 'two'
          loop do 
            puts 'three'
            throw :triple_loop, "return"
          end
        end
      end
    end

# 汚染されたオブジェクト
# Rubyにはセーフレベルという、外部からの入力によって危険な操作が行われることを未然に防ぐ機能がある
# 環境変数やコマンドライン引数など、外部からの入力は汚染されたオブジェクトとして扱われる。
# 汚染されているとみなされるオブジェクトと、禁止される操作はセーフレベルごとに異なり、
# ほとんどの環境ではデフォルトのセーフレベルは０（$SAFEに入っている値）で、0~4までがある。
# 一度$SAFEの値を上げてしまうと、下げることはできない。
# 一時的に上げる方法として、Procオブジェクトの中でだけセーフレベルを上げることができる。
$SAFE #=>0
level4 = Proc.new { $SAFE = 3 }
level4.call # => 3
$SAFE # => 0

# 割り込みハンドラの定義
# Kernel#trapを用いると割り込みのシグナルに対応するハンドラを登録できる。
# 下記を実行中にCtrl-Cを押すとputsして終了する
# 特別なシグナルの値として:EXITがあり、プログラムの終了直前に実行することができる
trap :INT do
  puts "\nInterrupted!"
  exit
end

loop do
  sleep 1
end

9-1 Methodオブジェクト
Rubyでは、メソッドもオブジェクトにできるんだぜ！
9-1-1 Methodオブジェクトの取得
Object#method
を使うとMethodオブジェクトを取得できる
  array = [1, 2, 3, 4, 5]
  array_shift = array.method(:shift)
  array_shift.call
メソッドオブジェクトは、生成された瞬間のメソッドの情報を内部的に持つので、
メソッドオブジェクトの後に、元々の呼び出し元のメソッドを変更しても、
その影響は受けない。

9-1-2 メソッドに関する引数の情報
Method#arityは、メソッドの実行に必要な引数に関する情報を取得できる。
デフォルト引数、可変長引数がある場合は、（必須の引数の個数 + 1） * -1となる。
上記がいくつあっても、-1としか表示されない。
  class Arity
    def arity_val_1(x);end
    def arity_val_2(*x);end
    def arity_val_3(x, *y);end
    def arity_val_4(x = 1);end
    def arity_val_5(x = 1, y);end
    def arity_val_6(x = 1, y = 1);end
    def arity_val_7(x = 1, y = 1, *z);end
  end
  
  arity = Arity.new
  arity.method(:arity_val_1).arity
  arity.method(:arity_val_2).arity
  arity.method(:arity_val_3).arity
  arity.method(:arity_val_4).arity
  arity.method(:arity_val_5).arity
  arity.method(:arity_val_6).arity
  arity.method(:arity_val_7).arity

Method#Parameterを使うと、引数の情報を配列で受け取れる。
:reqは、必須引数、:optはデフォルトがある引数、
:restは可変長引数、 :blockはブロック引数
  arity.method(:arity_val_1).parameters
  arity.method(:arity_val_2).parameters
  arity.method(:arity_val_3).parameters
  arity.method(:arity_val_4).parameters
  arity.method(:arity_val_5).parameters
  arity.method(:arity_val_6).parameters
  arity.method(:arity_val_7).parameters

9-1-3 メソッドの持ち主、名前、レシーバ
Methodオブジェクトは保持しているメソッドの持ち主、名前、レシーバを取得できる。
Method#owner:メソッドの定義されたクラス・モジュール
Method#name:元のメソッドの名前
Method#receiver:Methodオブジェクトが作られたインスタンス
  array_shift.owner
  array_shift.name
  array_shift.receiver

9-2 MethodクラスとUnboundMethodクラス
Methodクラスは、特定のインスタンスに紐付いていたが、
特定のインスタンスに紐付いていないオブジェクトが欲しい場合はUnboundMethodを使う。
作成方法は二種類。Module#instance_methodで生成するか、
Methodオブジェクトに対してMethod#unbindを使う
Unboundメソッドを使うには、オブジェクトにUnboundMethod#bindしないといけない。
bindできるのは、もとのメソッドを持つクラスか、そのサブクラス、
モジュールかそのモジュールをincludeしていることが条件
  unbound1 = Array.instance_method(:shift) #モジュールはクラスにincludeされているので、クラスから呼び出す
  unbound2 = array_shift.unbind
  bind1 = unbound1.bind([1,2,3])
  bind2 = unbound2.bind([1,2,3])

9-3 MethodオブジェクトとProcオブジェクト
Procオブジェクトの方が、クロージャが使えるので、
手続きオブジェクトとしては有能。
ただ、Methodオブジェクトは、手続きとそれを適用するオブジェクトが固定され、
その呼出を繰り返す必要がある時に有用。
まぁ、あんま使われないと。
9-3-1 Methodオブジェクトの使われ方
詳細は省略するが、引数の数を調べて、昔のrubyのversionでかどうかを判定し、
判定結果にしたがってメソッドを定義している。
使い方よりもむしろ、下記みたいに書けることの方が驚きなんですけど。
  if a == b
    def a_method
      ...
    end
  else 
    def a_method
      xxx
    end
  end

あとは、関数ポインタみたいに使うやりかた。
  case hoge
  when condition_a
    @func = hogehoge.method(:method_a)
  when condition_b
    @func = hogehoge.method(:method_b)
  when condition_c
    @func = hogehoge.method(:method_c)
  when condition_d
    @func = hogehoge.method(:method_d)
  end
みたいな。

10-1 オブジェクトについて調べる
  class TestRefrection
    CONSTANT = "CONSTANT"
    attr_accessor :rw
    attr_reader :r_only
    attr_writer :w_only
    @@class_variable = :class_variable
    
    def initialize
      @rw = :rw
      @r_only = :r_only
      @w_only = :w_only
    end
    
    def public_method
      :public_method
    end
    
    def self.singleton_method
      :class_singleton_method
    end
    
    protected
    def protected_method
      :protected_method
    end
    
    private
    def private_method
      :private_method
    end
    end    
  end

  test = TestRefrection.new

  test.instance_variables #インスタンス変数を全て表示
  test.instance_variable_defined? :@rw # 特定のインスタンスが定義されているか（文字列かシンボル）

  test.instance_variable_get :@w_only #getできないはずのものをgetできる
  test.instance_variable_set :@r_only, :setted #setできないはずのものをsetできる

  test.methods #private method以外を取得
  test.public_methods #public methodを取得。falseを指定すると親クラスのものを含めなくなる
  test.private_methods #private methodを取得。falseを指定すると親クラスのものを含めなくなる
  test.protected_methods #protected methodを取得。falseを指定すると親クラスのものを含めなくなる
  TestRefrection.singleton_methods #ModuleによってMix-inされたものも含め、全ての特異メソッド(この場合クラスメソッド)を取得
  TestRefrection.singleton_methods false #変数にfalseを入れるとこのオブジェクトに定義されたもののみを取得
  TestRefrection.methods false #この方法でもOK
  
  test.respond_to? :public_method
  test.respond_to? :private_method, true #privateを検索するには第二引数にtrueが必要
  
  test.send :private_method #sendは、どんなメソッドも呼び出せる。（メソッドを呼び出すシンボルもしくは文字列）
  test.__send__ :private_method #同じもの。オーバーライドされてる可能性を考慮して、こっちの方が良い場合がある
  

10-2 クラスについて調べる
  TestRefrection.class_variables #class変数を全て参照
  TestRefrection.class_variable_defined? :@@class_variable #class変数が定義されているか
  TestRefrection.class_variable_get :@@class_variable #class変数のget
  TestRefrection.class_variable_set :@@class_variable #class変数のset
  TestRefrection.constants #定数全てを参照
  TestRefrection.const_get :CONSTANT #定数をget
  TestRefrection.const_set :CONSTANT, "constant" #定数をget
  
  #インスタンスメソッドの取り出し。10-1で記述したものとほぼ同じ。
  TestRefrection.instance_methods
  TestRefrection.public_instance_methods
  TestRefrection.private_instance_methods
  TestRefrection.protected_instance_methods
  
  #特定のインスタンスメソッドが定義されているかも参照可能。継承されたものでもヒットする。
  TestRefrection.method_defined? :public_method #private_method以外にヒット
  TestRefrection.public_method_defined? :public_method
  TestRefrection.private_method_defined? :private_method
  TestRefrection.protected_method_defined? :protected_method
  
  TestRefrection.ancestors #継承関係を取得
  String.included_modules #includeされているモジュールを取得
  TestRefrection.superclass #スーパークラスのみを取得
  
  #Module.nestingはクラスのネスト構造を調べる。省略。
  
  TestRefrection.class_eval do #remove_methodは、private methodなのでevalで呼び出す
    remove_method :private_method #このクラスで定義されているメソッドのみをなかったことにする
  end

  #メソッドの定義場所を調べる(6章Columnに記載)
  #Proc, Method, UnboundMethodのsource_locationを用いる
  test.method(:public_method).source_location

10-3 イベントをフックする
モジュールやクラスが操作された時に処理を行うための方法
  Module#included -> モジュールがincludeされたときのフック
  Module#extended -> モジュールがincludeされたときのフック
  Class#inherited -> クラスが継承された時のフック
  Module#method_added -> メソッドが追加された時のフック
  Module#method_removed -> メソッドが削除された時のフック
  Module#method_undefined -> メソッドが未定義になった場合のフック
  

疑問点
  ClassクラスはModuleクラスを継承している。そのため、Moduleクラスのメソッドが呼び出せるのはわかる。
  Classクラスのインスタンスは、なぜかClassを継承していないので、Moduleを継承していないはず。
  なので、なぜClassクラスのインスタンスからModuleのメソッドが呼び出せるのか？

