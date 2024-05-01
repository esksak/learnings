# 変数
# コマンド展開
# `cmd`か$(cmd) かだが、``は読みにくいので、$()が使われる
hard_to_read=`echo "back quote is a bit tricky"`
easy_to_read=$(echo "$() is easy to read what actually is")

# 変数展開：値を置き換える演算子
# 変数が定義されていない場合に既定値を返す（| みたいなもの）
# ${var:-word}: varが存在し、nullでない場合はその値を、それ以外はwordを返す。
# ※コロンを省くとnullチェックがなくなり、変数が存在すれば、という条件になる。

# countが定義されていないとき、0を返す
echo ${count:-0}

# 位置パラメーター（$1とか）にも変数展開は使える。
filename=${1:-hogehoge}

# 変数が定義されていない場合に変数に既定値をセットする（|=みたいなもの）
# ${var:=word} : varが存在し、nullでない場合はその値を、それ以外はvarにwordを代入し、その値を返す。
# ※コロンを省くとnullチェックがなくなり、変数が存在すれば、という条件になる。

# countが定義されていないとき、countに0をセットし、0を返す
echo ${count:=0}

# 変数が定義されていない場合に発生する予期せぬエラーを回避する
# ${var:?message} : varが存在し、nullでない場合はその値を返し、
# それ以外は"var : message"を表示し、スクリプトやコマンドを強制終了する。
# ※コロンを省くとnullチェックがなくなり、変数が存在すれば、という条件になる。

# countが定義されていないときはcount:undefinedというメッセージを表示して終了する
echo ${count:?"undefined"} 

# 変数が定義されている場合に、指定の値を返す
# ${var:+word}: varが存在し、nullでない場合はwordを返す。それ以外はnullを返す。
# ※コロンを省くとnullチェックがなくなり、変数が存在すれば、という条件になる。

# countがnullでなければ、countの値によらず、1（trueの意味）を返す
echo ${count:+1}

# 変数展開：マッチングのための演算子
# ${variable#pattern}：変数の値の先頭にパターンがマッチした場合、
# マッチする最短の文字列を削除して残りの部分を返す。
# ##とすると、マッチする最長の文字列を削除して残りの部分を返す

# ${variable%pattern}：変数の値の末尾にパターンがマッチした場合、
# マッチする最短の文字列を削除して残りの部分を返す。
# %%とすると、マッチする最長の文字列を削除して残りの部分を返す

pathname=/home/tolstoy/mem/long.file.name
echo ${pathname#/*/} # => tolstoy/mem/long.file.name（/home/までを削除）
echo ${pathname##/*/} # => long.file.name（/home/tolstoy/mem/までを削除）
echo ${pathname%.*} # => /home/tolstoy/mem/long.file（.nameまでを削除）
echo ${pathname%%.*} # => /home/tolstoy/mem/long（file.nameまでを削除）


# 位置パラメーター
# $#：引数の個数を表す。shiftによって減算してループを回せる。
while [ $# != 0 ]
do
    shift #$#を１個減らし、$1に$2の値をセットする（１個左にずらす）
done

echo $* # 指定された全ての引数を「一つの」文字列として表す
echo $@ # 指定された全ての引数を「個別の」文字列として表す（他のプログラムに引数をそのまま渡すときはこっちを使う。）

# 特殊な変数($で実体)
echo $0 # シェルのプログラム名
echo $? # 直前のコマンドの終了ステータス
echo $$ # シェルのプロセスID
echo $! # 最後にバックグランドで実行されたコマンドのプロセスID
echo $- # シェルを起動する際に指定されていたオプションを表示

echo $HOME  # HOME:ホームディレクトリ
echo $PWD # カレントディレクトリ
echo $PATH # コマンドのパス
echo $PPID # 親プロセスID
echo $IFS # フィールドの区切り文字。通常はスペース

# 使わなさそうなその他の特殊変数
# LINENO：シェルスクリプトや関数の中で現在実行されている行番号
# PS1:プロンプトして表示される文字列。通常は＄
# PS2：行が継続中の場合のプロンプト文字列通常は＞
# PS4:set -xを使って実行をトレースしている際のプロンプト文字列。通常は＋
# ENV:対話的なシェルが新しく起動される際にのみ使われる。
#     この値を変数展開した結果が、シェルの起動時に読み込まれるファイル名として使われる。
# LANG：ロケール名の既定値
# LC_ALL:現在のロケール名
# LC_COLLATE:文字の並べ替えに関して使われるロケール名
# LC_CTYPE:正規表現のマッチングの際に文字クラスを判定するためのロケール名
# LC_MESSAGES：出力されるメッセージのためのロケール名
# NLSPATH:LC_MESSAGESで指定された言語に対応するメッセージカタログが置かれている場所


# 終了ステータス
# 0が正常終了でそれ以外は異常終了

# readonly: セットした変数に、readonlyをつけることができる
hoge="hoge"
readonly hoge

# 変数の文字カウント：${#variable}は文字数を返す。

# if文
# if command
#   then
#     ...
# elif command2
#   then
#     ...
# else
#     ...
# fi

# case文
# case $1 in
#   -f)
#       ;;
#   -d | --directory) #長いオプションも受け付けてる
#       ;;
#   *)
#   #esac直前の";;"は省略可能
# esac

# for文
# for i in hogehoge
# do
#   ...
# done
# "in hogehoge"を省略すると、コマンドライン引数($@)に対してループする。

# while文/until文
# whileはconditionがtrueの間ループ（falseで抜ける）
# untilはconditionがfalseの間ループ（trueで抜ける）

# while/until condition
# do
#     statements
# done

# breakとcontinue
# break numとすることで、何個外側のループへ抜けるのか指定できる
# break 1はbreakと同じ
