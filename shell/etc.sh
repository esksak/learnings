# ctrl+D -> ファイルの終了
# ctrl+H -> backspace
# ctrl+J -> 改行

# 正規表現
# POSIXでは正規表現の構文を２種類のみ定義している
# grepで使われているBRE（Basic Regular Expression）
# egrepで使われているERE（Extended 〜）
# 昔はegrep/fgrepもあったが、今はgrepに統合されている（それぞれ-Eと-F）

# 特殊ファイル
# /dev/null
# このファイルに送られるデータは全て消去される。

# /dev/tty (teletypewriter)
# かならずユーザーの入力を保証したいときに使われる。
# つまり、入力リダイレクトとして使うと、ユーザーが使用している端末が入力になる。

# 入力を、test.txtに書き出せる
cat /dev/tty > test.txt

# 出力できる
cat test.txt >> /dev/tty

# $$: プロセスIDの取得。主に、あるファイルを一意にしたいときなどに使われる

# #! /bin/sh - などのように最後に-をつけるとオプションをこれ以上記述しない
# という意味で、特定の種類のセキュリティアタックを防げる

# echo -nで出力値を改行せずに返す
# printfも使える

# who: ログインしているユーザーを一覧表示  

