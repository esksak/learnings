    # ブロック
# ブロックがあるかどうかの判定はblock_given?で可能
# yieldはブロックの戻り値を返す
# blockの中でnextを呼び出すと、blockの呼び出し元に戻る。nextの引数は戻り値となる。
# breakした場合は戻り値とならない。
# yieldの引数はブロックの引数となる。
# 仮引数の＆→ブロックをProcオブジェクトとして受け取る
# 実引数の＆→Procオブジェクトをブロック化。
# Procオブジェクトの代わりに&メソッド名とすると、to_procしたあと、ブロック化してくれる

puts "Method can yield its process to block."
=begin
yields keyword enables you to access handover the process to blocks.
=end
def yield_name(name)
puts "In the method! Let's yield."
yield("Kim") if block_given?
puts "In between the yields!"
yield(name) if block_given?
puts "Block complete! Back in the method."
end
yield_name("Eric") { |n| puts "My name is #{n}." }

def block_sample (val = "abcdefghijklmnop", &block) #block引数は後ろじゃないと受け取れない
    b ||= block.call(val) if block #yield valと同じ結果
    yield val
end
block_sample &:upcase #&でProcオブジェクトにしてからブロック化してくれる
block_sample {|a = "procsample"| a.upcase}

# Proc: ブロックを変数化したもの。書き方が４つある
Proc.new {{val| puts val}
proc {|val| puts val}
lambda {|val| puts val}
->(val) {puts val}


puts "Lambda is like proc, the difference between lambda and proc shows as follows."
=begin
lambda is super similar to proc, except two main differences.
First, a lambda checks th number of arguments passed to it, while proc does not.
Second, when a lambda returns, it passes control back to the calling method;
when a proc returns, it does so immediately, without going back to the calling method.
=end
def sample_proc
_proc = Proc.new { return "Proc Never came back to method. just return the value and ends." }
_proc.call
"Never com here!!"
end


def sample_lambda
_lambda = lambda { return "This never shows to console. just back to the method." }
_lambda.call
"Lambda shows this message regardless of calling return in its process!!"
end

puts sample_proc
puts sample_lambda

8-1 Procクラス
8-1-3 Proc#===メソッド
Procオブジェクトの===メソッドは、他のオブジェクトと違い、
Procオブジェクトを実行するように実装されている。
case文での活用が考えられる。
case式に渡された値が引数で、
when節に渡されたオブジェクトがレシーバとなって、===が実行される。

  def what_class obj
    case obj
    when proc { |x| x.kind_of? String }
      String
    when proc { |x| x.kind_of? Numeric }
      Numeric
    else
      "Object that is not String nor Numeric"
    end
  end
  
  what_class "aaaa"
  what_class 42
  what_class []

8-1-5 Procオブジェクトとブロック
  実引数のブロックをProcオブジェクトにする→仮引数に&をつける
  実引数のProcオブジェクトをブロックにする→実引数に&をつける

8-1-6 Proc#curry
引数としてx,yのような複数の引数を取る関数に、
xだけ渡してyを引数として取る関数を新たに作ることをカリー化という。
Proc#curryを使うことでカリー化が可能
curryを使わなくても、Procオブジェクトを返すメソッドを定義することで可能
  add = proc { |x, y| x + y}
  inc = add.curry.(1) #callは省略できる。.()の代わりに[]もOK
  inc[2]
  
  #curryを使わない場合
  inc = proc { |y| add.(1, y) }
  inc.call(2)

8-2 Proc#new以外のProcオブジェクトの作り方

8-3 Proc.new/Kernel.proc/Kernel.lambda
8-3-1 return/break

lambdaで生成されたProcオブジェクトの方がよりメソッドに近い挙動を示す。
lambdaのbreakとreturnは同じ挙動。
メソッド	return	break
Proc.new/Kernel#proc	メソッドを抜ける	例外が発生
lambda	制御を抜ける	制御を抜ける

8-3-2 引数の違い
ブロックは引数の数が違っても許容されるが、
lambdaは、より引数に厳密で、同じ引数でないとエラーとなる。

8-3-3 Proc#lambda?
生成されたオブジェクトがlambdaかどうかは、
Proc#lambdaで確認できる

8-4 Rubyでのクロージャ
クロージャとは、引数以外にも関数定義時のコンテキストに含まれる変数などの情報を持つ関数オブジェクトのことを言う
ググると、状態を保持する関数のことらしい。
たとえば、呼び出す度にインクリメントされた値を返す関数は、クロージャなんだそう。
クロージャの要件として、
1. 関数のスコープ内で変数を定義し、
2. その関数の中で内部関数を作って
3. その内部関数からから、先ほどの変数を参照する
とのこと。
http://dqn.sakusakutto.jp/2009/01/javascript.html

  def closure_sample
    x = 0
    Proc.new { x += 1}
  end
  cl = closure_sample
  cl.call #1
  cl.call #2
  cl.call #3
