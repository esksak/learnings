# 基本的な組み込み関数

"foobar".empty? # length == 0 と同じ
"foobar".size  # もしくはlength
"Alice Bob Charlie".include? 'Bob'
"Highlight".start_with?("High")
"High" + "light" # 文字列の結合
"Higher! " * 3 # 文字列の繰り返し
"Result %04d" % 42 # 42を0042として文字列にする
str = "Alice"; str << " Bob" << " Charlie" # 文字列の結合

# String#slice: 部分文字列の取得。[]でショートハンド
str = "abcdefg hijklmn opqrstu"
str[4]
str[4, 6] #第二引数は取得文字数
str[4...9]
str[/bcde/]

# strip:文字列前後の空白を取り除く。片方だけのときはrstrip/lstripを使う
# chomp: \nをひとつだけ取り除く
# chop: 何でも一文字最後の文字を取り除く
# squeeze: 連続した重複文字を一つにまとめる。まとめる重複文字を第一引数に指定可能。
# downcase, upcase, capitalze, swapcase.reverse
str = "     \taaabbbcccdddeee    \n\n\n"
str.strip
str.rstrip
str.lstrip
str.chomp
str.strip!.chop
str.squeeze('a-c')#a,b,cのみsqueeze
str.upcase.downcase.capitalize.swapcase.reverse

# 文字列の置換には、sub,gsubを用いる。subは最初の一つだけを置換、gsubは再帰的に置換
# 第二引数の代わりにブロックを渡せる。
str.gsub(/[A-z]/, "x")
str.gsub(/[A-z]/, &:upcase)

# split: 配列への変換。第一引数にセパレータ（文字列 or 正規表現）、第二引数に分割最大数
str.split(//) #文字列を文字の配列に変換

# each_char, each_byte, each_line: 繰り返し処理

# 文字列の入出力
# puts/print/printf
# Kernel#pは、オブジェクトを人間が理解しやすい文字列として出力するデバッグ用メソッド
# puts, print,printfがto_sしたものを返すのに対し、Kernel#pは、.inspectの戻り値を返す

# sprintf
sprintf(%04d, 1) # => 0001
'04d' % 1 # 上記のショートハンド

# getsは、ARGFから一行ずつ読み込む。
# ARGFは、コマンドライン引数がなければ標準入力が使われる
# コマンドライン引数があった場合は、$stdin.getsから取れる

# 外部コマンドの実行
# Kernel#`を利用すると、結果が標準出力に出る。
# 標準出力に出す必要がないときは、Kernel#Systemを使う。
# execコマンドも、外部コマンドを実行するが、Rubyプロセスに戻らず終了する
# spawnを使うと、子プロセスで外部コマンドを回せる。終了の待ちあわせには、Process.waitpidを使う
# 終了ステータスが0の場合true、それ以外がfalse
# 直前のコマンドの終了ステータスは、$?で詳細を確認できる（Process::Statusオブジェクト）。
pid = spawn('uname')
Process.waitpid pid

# system/exec/spawnは第一引数にハッシュを指定できる。
# これを用いて外部コマンドのプロセスの環境変数を上書きしたり新たに追加することができる
system({'HOGE' => 'piyo'}, 'echo $HOGE') # => piyo

# オブジェクトの情報を返すメソッドや比較演算子
o = Object.new
o.class
o.is_a?(Object)
o.nil?
o.frozen?
o.tained? #汚染されているかどうか
o.taint #汚染させる
o.untaint #汚染解除
o.tap {|v| puts v} #自身をブロック引数してブロックを実行し、自身を返す関数
o == Object.new #false。同一性を評価するため。必要に応じてオーバーライドが必要
o.freeze # オブジェクトへの変更を禁止する
o.dup # or o.clone オブジェクトのshallowコピー（汚染状態を含めてコピーされる）

# 数値クラス
# Numeric -+--Integer -+--Fixnum (整数)
#          |           |
#          |           +--Bignum (大きな整数)
#          |
#          +--Float (浮動小数点数)
# Fixnum/Bignumは、自動的に切り替わるので意識しなくてOK
# Fixnum/Bignumはnewでのインスタンス生成が禁止。

# Numeric
0.zero?
0.nonzero?
356.integer?
3.real?
3.5.ceil # 切り上げ
3.5.floor # 切り下げ
3.5.round # 四捨五入
3.5.trancate # 自身と0との間で自信に最も近い整数を返す（0につかづくように切り捨てる）

# step関数は、第一引数に与えられた上限の数値まで、第二引数にステップの幅で繰り返す
1.2.step(2.0, 0.2) { |v| puts v }

# Integer
1.odd?
2.even?
3.next #もしくは3.succ
3.pred
4.times
5.upto
6.downto

# 整数値は、２進、８進、１６進で書ける
# bit→0b★
# ８進→0
# hex→0x

# 大きな数字の見栄えのためだけに、アンスコ（_）が使える。
123_456_789

# to_sの引数に基数を指定できる
30.to_s
30.to_s(2)
30.to_s(8)
30.to_s(16)

# chrで整数に対応する文字コードに変換
(65..70).map &:chr

# 整数以外を整数に変換するにはto_iメソッドか、Kernel#Integerを用いる

# Rational: 有理数クラス。第一引数に分子、第二引数に分母を与える
# 除算の際に /ではなく、Numeric#quoを使うと、戻り値をRationalオブジェクトとできる。
# to_fでfloat化
Rational(3, 10) #=> 3/10
r = 3.quo(10) #=> 3/10
r.to_f #=> 0.333333...

# いくつかのクラスにto_rメソッドが定義されている。

# Complex 第一引数に実部、第二引数に虚部を与える、もしくは、文字列で与える。
Complex(2, 3)
c = Complex('2+3i') #spaceがあるとエラー
c.real
c.imaginary

# いくつかのクラスにto_cメソッドが定義されている。

# Range
# 5..10 -> 5から10の範囲を持つ範囲オブジェクト
# 「...演算子」にすると、lastを含まなくなる。
# 実際には、Rangeクラスのオブジェクトなので、Rangeクラスのコンストラクタからも呼べる
Range.new(5, 10, true) #trueで...演算子。デフォルトfalse

# succメソッドを使って次の値を取得できる
# 文字列オブジェクトの場合、アルファベットは26進数、数字は10進数として返す。
"a".succ # =>  "b"
"z".succ # => "aa"
"Az".succ # =>  "Ba"
"4".succ  #  => "5"
"a9".succ # =>  "b0"

# Regexp
# ===はboolean, =~はマッチした位置を返す。
# matchメソッドを使うと、MatchDataオブジェクトを取得できる。
# scanメソッドを使うと、マッチした文字列を配列で受け取れる。
# i（大文字・小文字の区別をしない）などのpattern　optionがある

# グルーピングと後方参照、部分式呼び出し
# \1, \2などで参照できるが、Rubyプログラムからも$1,$2と参照できる。
# 正規表現のグルーピングには、ラベルをつけられる。?<label>patternという書き方。
# 後方参照で使う場合は、\k<label>で参照できる。Rubyからの呼び出しは、:labelで参照できる。
# 式そのものを後方参照する場合、部分式呼び出し\g<n>が使用できる。
# \1との違いは、\1は、マッチしたものそのものを参照できるのに対して式そのものを繰り返す点が異なる。
phone = '080-1234-5678'
/([0-9]+)-\g<1>-\g<1>/ === phone # => true
/([0-9]+)-\1-\1/ === phone # => false（マッチした文字そのものを参照するため）

# 先読みと後読み
# 文字列の前にこんな文字列があって、文字列の後ろにこんな文字列があるような文字列のみヒットさせたいときに使う。
# 後よみ、先読みが直感と逆だが、前にくるものを後読み、後ろに来るものを先読みと言うみたい。
# /(?<=lookbehind_pattern)(target_pattern)(?=lookahead_pattern)/の形
# =を!にすると、論理値が反転する


# Comparableモジュール
# Comparableモジュールをincludeして、<=>演算子を定義すると比較演算子を使えるようになる。
# 左辺が右辺の後ろに来るとき1, 前に来るとき-1、同じ場合0を返す必要がある
# 降順への並び替え
array.sort { |first, second| second <=> first }

class Ruler
  include Comparable
  attr_accessor :length
  def initialize len
    length = len
  end
  
  def <=>(other)
    length <=> other.length
  end
end

# Enumerableモジュール: オブジェクトの集まりを自在に操ることができる。

# 繰り返し処理を行うメソッドを提供する。
(1..5).each_with_index { |val, index| puts "#{index} = #{val}" } #インクリメントされるインデックスも同時に渡す
(1..5).reverse_each { |v| puts v }# 末尾から逆順に繰り返す
(1..5).each_slice(2) { |a, b| puts "#{a}, #{b}" } #第一引数の数に区切って繰り返す
(1..5).each_cons(3) { |a, b, c| puts "#{a}, #{b}, #{c}" } #連続した要素をひとつずつずらしながら渡す
# (1..5).cycle {|v| puts v } #無限ループ

# map, collect: ブロックを評価した結果の配列を返すメソッド

# 要素が特定の条件を満たしているか
[true, true, false].all? #全ての要素が真の場合true
[false, false, false].none? #全ての要素が偽の場合false
[true, false, false].any? #一つでも真があればtrue
[true, true, false].one? #真が一つだけであればtrue
[1, 2, 3, 4, 5].all? { |v| v.integer? } #ブロックも渡せる。その場合、ブロック内に真偽値を判定するための式を記述する

# grep: 文字列の取り出し。===を比較をする。その際、===のレシーバーは引数となる。
%w(Alice Bob Charlie).grep(/^a/i) # /^a/i（Regexp）がレシーバー
%w(Alice Bob Charlie).grep("Alice") # "Alice"(String)がレシーバー
# grepを使って述語メソッドを取り出す
String.methods.grep(/\?/)

# select/reject: 要素の取り出しと除外
# select!/reject!は、該当する要素がなかった場合nilを返す
(0..10).select { |v| v.even? }
(0..10).reject { |v| v.even? }

# take/drop: 先頭から任意の数を取り出す/除外する
(0..10).take 5
(0..10).drop 5

# take_while/drop_while: 先頭からある条件までの数を取り出し、除外はを使う
(0..10).take_while { |v| v < 5 }
(0..10).drop_while { |v| v < 5 }

# find/detect: 戻り値が真となった最初の要素を返す
[1,3,3,4].find { |i| i.even? }

# inject/reduce: 畳込み演算
[1, 2, 3, 4].inject(5) { |ret, v| ret += v } #ただのΣ。
[1, 2, 3, 4].inject(5, :+) #シンボルの形として受け取れる

# each_with_object: 配列の各要素から別のオブジェクトを作れる
# ブロックの引数がreduceと逆（ブロックの第一引数が現在の要素の値, 第二引数が直前のブロックの戻り値）
%w(Alice Bob Charlie).each_with_object({}) { |name, ret| ret[name] = name.length }

# group_by: 同じ値を返すものでグループ化できる
[1, 3.0, 5, 2.0, 6, "Alice", "Bob"].group_by { |v| v.class } # クラスごとにグループ化
# partition: グループを2つに分ける
[1, 3.0, 5, 2.0, 6, "Alice", "Bob"].partition { |v| v.is_a? Integer } # 整数か否かでグループ化

# min_by, max_by, minmax_by: ブロックで何に基づいた最大値かを自分で定義して返す

# Array
# 全ての要素は同一のオブジェクトを指すので、一つが破壊的に変更されると全てに波及する。
Array.new(5, 1)

Array.new(3) { |index| index.succ }

array = [4, 3, 2, 1]
array.empty?
array.length
array.include? 4
array + [0, -1] # 連結
array - [3, 2]  # 削除
array * 3 # 繰り返し

# 要素の取得
array[2]
array.at(2)
array[2, 3] # 2個目の要素から３個とる。index outof boundsとならない
array [2..3]# 要素２～３を取る。
array.values_at(0, 3, 4) # 飛び飛びの要素を取得
array.first(2) # 先頭からn個（引数省略の場合は一つ）
array.last(3) # 後ろからn個（引数省略の場合は一つ）
array.sample(2) # 要素をランダムでn個返す
array[-1] # 後ろから一番目

# assocは、Hashライクな配列の場合にキーから値を取得する
array2 = [[:Alice, "Alice"], [:Bob, "Bob"], [:Charlie, "Charlie"]]
array2.assoc(:Bob)
  
# 要素の末尾に追加と削除
array.push 3
array << 3
array.pop

# 要素の先頭に追加、削除
array.unshift 1
array.shift

# keep_if/delet_if: 条件に該当する要素の削除 (select/rejectと同じ挙動)

# 要素の値、indexから削除
array.delete 4 #4.0も削除される。
array.delete_at 0

# 配列の整形
array << nil
array.compact #nilを除いたものを返す
array.uniq #重複要素を削除
array.reverse #順序を逆に
array2.flatten #多次元配列を平ら（一次元？）に

# 配列の転置
array2.transpose

# 要素の連結。引数はセパレータ
array.join('-')

# Hash
ほとんどのクラスが継承しているObjectクラスにはhashメソッドがあり、
このhash値の値で連想配列を作る。
Objectが更新されるとhash値は代わるため、Mutableなオブジェクトはキーにすべきではない。
ただし、Stringだけは特別に変更されても大丈夫な設計にしてある

#要素の取得
obj[prop]
obj.fetch[prop, "default value"] # 存在しないキーへのアクセスに例外を投げる
obj.fetch(prop) {|key| "default value"}

# 要素との追加
hash[prop2] = value
hash.store(key, value)


繰り返し処理→each_key, each_value

追加→［］削除deleteメソッド
hash =  {:Alice => "Alice", :Bob => "Bob", :Charlie => "Charlie"}
hash[:Dave] = "Dave"
hash.delete :Dave

select!/reject!は、該当する要素がなかった場合nilを返すが、
keep_if/delet_ifは、要素がなかった場合要素自身を返す。(select/rejectと同じ挙動)
こっちのほうが直感的だよなぁ？

要素の結合
mergeメソッド。キーが重複した場合、引数で渡したもので上書きされる。
merge!, updateは上記の破壊的なメソッド。

  hash.invert #キーと値の入れ替え
  hash.has_key? :Alice #キーが存在んbむyj、１１
  hash.key? :Alice #キーが存在しているかその２
  hash.member? :Alice #キーが存在しているかその３
  hash.include? :Alice #キーが存在しているかその４
  hash.has_value? "Alice"#値が存在しているか
  hash.keys #キー一覧取得
  hash.key "Alice" #特定の値を持つキーの取得
  hash.values #値一覧取得
  a, b = hash.values_at(:Alice, :Bob) #特定の値の取得、多重代入可能

デフォルト値色々
  has_default = Hash.new("default") #デフォルト値に破壊的な操作を行うと変わってしまう
  has_default = Hash.new {|hash, key| Time.now} #存在しないキーが呼び出される度に参照される
  has_default.default = "DDDefault" #デフォルト値の設定・更新
  has_default.default_proc = ->(hash, key) { Time.now } # デフォルト値をprocオブジェクトで設定

デフォルトの代わりに、存在しないキーを参照した場合の処理をブロックとして扱える。
  has_default.fetch(:foo) { |key| puts "no #{key} key"}

ハッシュの変換
  hash.keys #keyの配列
  hash.values #valueの配列
  hash.to_a #配列への変換（[[key1, val1], [key2, val2]]）
  arr = [1,2,3,4]
  Hash[*arr] #偶数個の一次元配列からHashへの変換。[]なことに注意
  Hash[array2]配列の配列から作る

5-5-4 Enumeratorクラス
EnumerableオブジェクトをincludeしていないオブジェクトにEnumerableな機能を提供する
たとえば、StringクラスはEnumerableをincludeしていない
外部イテレータという柔軟な繰り返し処理の提供が強み。
eachを始めとしたメソッドをブロックなしで呼び出すと、Enumeratorオブジェクトが返ってくる。
to_enum, enum_forを使うとEnumeratorオブジェクトを取得可能
  "Alice".to_enum(:each_char)

Enumeratorには、with_indexというメソッドがあり、インデックスを一緒に取ってこれる。
  %w(Alice Bob Charlie).each.with_index { |name, index| puts "#{index} = #{name}" } 
上記なら、Enumerableのeach_with_indexと等価だが、
他のEnumerableモジュールのメソッドに対してインデックスを参照したいときに便利。selectとか。
  %w(Alice Bob Charlie).select.with_index { |name, index| index > 0 }

外部イテレータ
Array#eachやHash#eachを使ったイテレータは内部イテレーター。
こういうのは、オブジェクトの内部で閉じているから、複数のオブジェクトを一緒に回したい時とかに不向き。
Enumeratorは、nextと、rewindという２つのメソッドがある。
nextは要素を次に進める。rewindは最初にポインタを戻す。
nextは、要素がないと例外を出すが、loopでくくると、勝手に補足してくれる
selectやmapのようなブロックの戻り値を使用するタイプのメソッドの場合、
ブロックの戻り値に当たる値（ブロックの中身を記述する）はfeedで渡し、
メソッドの戻り値は例外StopIterationのresultメソッドから取ってくる。

  enum = %w(Alice Bob Charlie).select #selectのEnumeratorを取得
  loop do
    begin
      person = enum.next
      enum.feed /li/ === person # liに該当するものをtrueとして渡す
    rescue StopIteration => e
      p e.result #Alice, Charlieを表示
      break #忘れると無限ループ
    end
  end

5-5-5 Enumerator::Lazy
たとえば、下記のようにメソッドをchainするときに、普通にやると、
a.each_a.each_b.each_c.each_d....
each_aの処理が終わったあとにeach_b、という順番に処理するため、
配列の数が膨大のときに、時間が異常にかかる。
lazyを使うと、必要な処理だけを行えばよい場合にすぐおわらせられる。
  #lazyを使わないと、最初のmapでブロッキングされてしまう。
  #lazyをcallすると、Enumerator::Lazyオブジェクトが生成されるが、実行はされない
  odd_numbers = (0..Float::INFINITY).lazy.map{|n| n.succ}.select{|n| n.odd?}.take(3)
  odd_numbers.force #処理の実行にはforceを使う

5-6 Time
  Time.now
  Time.now.zone
  Time.now.getutc
  now = Time.now
  now.utc #timezoneをUTCに
  now.to_i
  now.to_s
  now.to_f
  now.to_r
  now.year
  now.month
  now.day
  now.hour
  now.min
  now.sec
  now.nsec
  now.wday #日曜日を0とした0~6の整数値
  now.yday #1月1日を1として年を通しての経過日数
  now.dst? #夏時間かいなか
その他いろいろ

5-7 IO/File
ポインタだけ。
ファイルの読み込み
ファイルの書き込み
表5.6はファイルを開く際のモード
表5.7はファイルを開く際のモード（定数）
アクセス位置の操作
エンコーディングの扱い
ファイルのロック
ファイルに関する情報の取得
属性や状態の取得
ファイルパスの操作

5-8 Dir
  Dir.pwd #カレントディレクトリ
  Dir.home #homeディレクトリ
  Dir.chdir 'tmp'
  Dir.chdir ('tmp') { |path| path.pwd} #実行後、ディレクトリは元のまま
  Dir.entries #ファイル一覧の取得
  Dir.mkdir #ディレクトリの作成

5-9 Thread
5-9-1スレッドの作成
Threadは、Thread.fork {#Threadで行いたい処理}で記述。
戻り値はThreadオブジェクト。
Threadの終了を待ってThreadの戻り値をもらうには、valueメソッド。
戻り値はいらず、待ち合わせだけしたいときは、joinメソッド
  files = Dir.chdir("Desktop") {|path| Dir.entries Dir.pwd}.grep(/txt$/).map { |v| "Desktop/" + v }
  threads = files.map { |file|
    Thread.fork {
      num = File.readlines(file).length
      "#{file} #{num}"
    }
  }
  threads[0].status #statusの取得
  threads[0].alive? # 生きてるか
  threads[0].stop? # 生きてないか
  Thread.list #生きているThreadの取得
  Thread.current #カレントスレッドを取得
  threads.map(&:value)

5-9-2 変数の扱い
  for文で複数のスレッドを生成する。itemは共用なので、全てbazと表示されてしまう。
  for item in %w(foo bar baz)
    Thread.fork do
      sleep 1 #forループはカレントスレッドで回るので、↓の行が実行されるよりも前にfor文が終わる
      puts item
    end
  end
  (Thread.list - [Thread.current]).each &:join # currentスレッドを除いたもののThreadを待つ

  forkに仮引数を渡すと、ブロックにそのまま渡してくれる。
  for item in %w(foo bar baz)
    Thread.fork item do |value|
      sleep 1 #forループはカレントスレッドで回るので、↓の行が実行されるよりも前にfor文が終わる
      puts value
    end
  end
  (Thread.list - [Thread.current]).each &:join # currentスレッドを除いたもののThreadを待つ

5-9-5 スレッドの操作
Sleepは自身でしかできない。Thread.stopを使う。
sleepした場合、タイムアウトを設定するか、他のスレッドからwakeupしてもらう必要がある。

5-9-6 例外の扱い
Threadの中で例外が起きても、Thread自体は何も言わない。
join/valueで待ち受けている場合、待ち受け側のスレッドで同じ例外が起きる。

5-9-7 スレッドの優先順位
Thread#priorityで優先順位の参照、更新ができる

5-9-8 ThreadGroup
Threadのグループ化ができる。
  group = ThreadGroup.new
  thread = Thread.fork {sleep 1}
  group.add thread #groupにthreadを追加
  group.list #groupに含まれるスレッドを表示

5-9-9 Mutex (= mutual exclusion)
Synchronizeのこと。
まず、Mutexオブジェクトを生成して、
Mutex#synchronizeのブロックに同期実行させたい処理を記述する。

  $count = 0
  mutex = Mutex.new
  def countup
    $count +=1
  end
  
  1000.times.map {
    Thread.fork { 
      mutex.synchronize { countup }
    }
  }.map(&:join)
  
  $count

同期処理するときは、デッドロックに気をつけないといけない。

5-10 Fiber
ある処理を途中まで実行して、その後任意のタイミングで前回の続きから処理を行うためのもの。
スレッドは、勝手にスケジューラーに登録されちゃうため、プログラマーが制御できない。
このように、自動的に与えられるスケジューラーのタイムスライスで実行されることをプリエンプティブというが、
Fiberはノンプリエンティブな軽量スレッドを提供する。

5-10-1 基本的な振る舞い
Fiber.newで生成されたオブジェクトは、すぐには実行されず、Fiber#resumeによって始めて実行される。
Fiber#resumeを呼び出した側を親、Fiberが子となる。
子から親に戻るには、Fiber.yield(クラスメソッド)を使う。

5-10-2 引数と戻り値
Fiberには引数と戻り値があり、初めのresumeで渡される引数が、Fiberのブロック引数になる。
さらに、初めのresumeは、yieldの引数を戻り値として受け取る。
で、そのyieldの戻り値は、二回目のresumeの引数を受け取る。
Fiberはyieldでブロックされていて、resumeは、そのyieldに引数を渡しつつ、
次のyieldの引数を戻り値としてもらうイメージ。
  fiber = Fiber.new { |first|
    puts "first resume called " + first
    puts "yield returns 'goodbye' to first resume"
    second = Fiber.yield('goodbye') #二回目のresumeが呼ばれるまでここでブロック
    puts "second resume called " + second
    'Bye!'
  }
  
  puts fiber.resume('hello')
  puts fiber.resume('hi')

5-10-3 ジェネレーター
Fiberを用いると、膨大な計算結果の配列を一度に構築するのではなく、
部分的な結果だけを計算して返し、次回また続きから計算するサブルーチンである
ジェネレーターを実装できる。
ジェネレーターは、実際の計算を最小限で済ませ、大きなデータを少ないリソースで扱うことができる。
  fib = Fiber.new {
    a, b = 0, 1
    loop do
      a, b = b, a + b
      
      Fiber.yield(a)
    end
  }
  10.times.map {fib.resume}
  fib.resume
  fib.resume

5-11 Process
Processはプロセスを管理するためのモジュールで、
デーモンプロセスの生成やプロセスの操作ができる。
子プロセスを複数用意して、時間のかかる処理を複数のプロセスで処理できる。
ポインタだけ置いておきますね。

子プロセスの生成
子プロセスの待ち合わせ
プログラムのデーモン化

5-12 Struct
構造体を表現するクラス
うーん、クラスとどう違うの？？と思ったら、
複数のフィールドを持つ単純なクラスを簡潔に定義するのに使うみたい。

5-12-1基本的な使い方
Struct.newは、Structクラスのサブクラスを新たに作って返す。
普通はインスタンスを返すので、ちょっと特殊。
  Human = Struct(:age, :gender) #左辺がサブクラスであることに注意

5-12-2メソッドの定義
インスタンスメソッドの定義もできるぽよ。

  #Struct.newが返す無名のクラスを継承することでこう書ける。
  class Human < Struct.new('Human', :age, :gender) #Struct.newの第一引数にサブクラス名を定義
    def teen?
      (13..19).include? age
    end
  end
  Human.ancestors

5-13 Marshal
オブジェクトを永続化するための機能を提供するモジュール
Marshal.dumpは、おbジェクトを永続化可能な文字列に変換し、
Marshal.loadは文字列からオブジェクトを復元する。
array = [1, "2", [3], Time.now]
m =Marshal.dump(array) #オブジェクトを文字列に書き出す。
Marshal.load(m) #オブジェクトの復元

5-13-3
Objectクラスのmarshal_dump. marshal_loadをオーバーライドすると、カスタマイズできるらしい。

5-14 ObjectSpace
実行中のRubyプロセス中に存在するあらゆるオブジェクトを操作するためのモジュール。
ObjectSpace.each_objectは、特定のクラス・モジュールとkind_of?の関係にある全ての
オブジェクトに対して繰り返し処理を行う。
ただし、即値であるFixnum,Symbol, TrueClass, FalseClass,NilClassは含まれない

ObjectSpace.id2refで、オブジェクトIDから実際のオブジェクトを取得できる。

ObjectSpace.define_finalizerは、あるオブジェクトがGCやスクリプトの終了時に
開放される際に実行する処理を登録する。
第一引数には対象のオブジェクト、第二引数にファイナライザとして実行するProcObjectを渡す。
ProcオブジェクトはブロックでもOK
o = Object.new
o.object_id.to_s(16)
ObjectSpace.define_finalizer(o, proc { puts "object id = #{o.object_id.to_s(16)} finalizing..."})
#exit #irbをexitすると、finalizingと表示される

7-3 eval
7-3-1 eval属
Kernel.#eval:selfが呼び出された箇所として式を評価
Module#class_evalレシーバのクラスをselfとして式を評価
Module#module_eval レシーバのモジュールのをselfとして式を評価
BasicObject#instance_eval レシーバのオブジェクトをselfとして式を評価

7-3-2 Kernel.#eval
evalは、文字列を評価する。
evalが評価する文字列の中には、メソッドの定義でも良い。したがって、
evalは、メソッドを定義するメソッドを作るのに使われる。
たとえばattr_accessorのような、メソッドの名前が違うだけで処理がほとんど一緒のときに便利。
templateに似ている。
  class AttrClass
    def initialize
      @attr = "attr"
    end
    
    def add_reader(instance_val_name)
      eval <<-END_OF_DEF # evalは文字列の評価なので、heredocが使える
        def #{instance_val_name}
          @#{instance_val_name}
        end
      END_OF_DEF
    end

    def add_writer(instance_val_name)
      eval <<-END_OF_DEF # evalは文字列の評価なので、heredocが使える
        def #{instance_val_name}=(val)
          @#{instance_val_name} = val
        end
      END_OF_DEF
    end
  end
  
  attr_obj = AttrClass.new
  attr_obj.respond_to? "attr" #この時点ではfalse
  attr_obj.add_reader "attr"
  attr_obj.add_writer "attr"
  attr_obj.respond_to? "attr" #trueになる
  attr_obj.attr = "newVal"
  attr_obj.attr #=> newVal
  

7-3-3 evalとBindingオブジェクト
Rubyでは、あるコンテキストで定義された変数やメソッドなどを
まとめたオブジェクトをBindingオブジェクトという。
Kernel#evalの第二引数にBindingオブジェクトを指定することで、
式がBinidingオブジェクトのスコープで評価されるため、
evalで式を評価する際に使用するコンテキストを指定できる。
Bindingオブジェクトは、Kernel#bindingメソッドで取得できる
  #オブジェクトのインスタンスをコンテキストとしたevalの例
  class EvalTarget
    def initialize
      @instance_val = 'instance variable'
    end
    
    def instance_binding
      local_val = 'local variable'
      binding
    end
    
    private
    def private_method
      'private_method'
    end
  end
  
  e1 = EvalTarget.new
  binding_obj = e1.instance_binding
  eval "@instance_val", binding_obj
  eval "local_val", binding_obj
  eval "private_method", binding_obj

7-3-4 module_eval/class_eval/instance_eval
式を評価するコンテキストとなるオブジェクトやクラス、モジュールを指定してevalするためのもの。
これらを使えばBindingオブジェクトを使用せずにコンテキストを指定できる。
コンテキストを指定できること以外にも、ブロックによる評価が可能というメリットがある。
詳細は省くが、外からクラス変数やprivateメソッドがさわる方法が紹介されている。
結構危険なきがする。
  e1.instance_eval do
    private_method
  end
module/class_evalで定義したメソッドはクラスインスタンスに対するメソッド定義なので、インスタンスメソッドになる。
instance_evalで定義したメソッドはオブジェクトに対するメソッド定義なので、特異メソッドになる。
  # ということは、クラスメソッドを定義するには、
  # Classに対してinstance_evalをすれば定義できる（他の方法があるのでやる意味ないけど）。
  str = "hello!"
  EvalTarget.instance_eval do
    def class_method
      puts "class_method" + str #ブロックなので外側のスコープの値を参照できるのが強み
      true
    end
  end

7-3-5 module_exec/class_exec/instance_exec
module_exec/class_exec/instance_execは、
evalと同じように式を評価できるが、
引数を取り、その引数をブロック引数として評価する式に渡せる。
例では、同名の変数がクラス内にあった場合に引数として渡して呼び出し元の
変数が参照されることを紹介している。
超ニッチじゃね？
