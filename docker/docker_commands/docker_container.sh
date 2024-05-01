#! /bin/zsh

# docker containerは、create/start/stop/rmが基本動作。
# create/startは、runコマンドを実行すれば一つにまとめることが可能

# docker container run [option] image名 [:タグ名] [引数]
# optionとしては下記がある
# -a: stdin/stdout/stderrにアタッチ
# -d: background
# -i: コンテナの標準出力を開く
# -t, --tty: 端末デバイスを使う
# --name: コンテナ名をつける
# --rm: 実行後にコンテナを削除
docker container run -it --name "test1" --rm centos /bin/cal

# docker container runで、container内のネットワークの設定もできる
# --addhost=[ホスト名:IPaddr]: container内の/etc/host内に、ホストを追加する
# --dns=[IPaddr]: containerで使うdnsのアドレスを指定
# --expose ホストマシンにバインドされる意図のあるportをexposeに記述しておくことで、どのportをpublishすれば良いかが分かりやすくなります。
# --mac-address=[MACaddr]: MACアドレスを指定
# --net=[bridge | none | container:<name | id> | host | NETWORK]: containerのネットワークを指定
# --hostname: コンテナのhostnameを指定
# -p (--publish) [hostのport:containerのport]: ホストとコンテナのポートマッピング
# -P (--pubpish-all): hostの任意のポートをcontainerに割り当てる
docker container run --rm  -p 8080:80 nginx

# docker container runで、環境変数などの設定もできる
# -e=[環境変数] (-env)
# --env-file=[ファイル名]
# --readonly=[true|false] コンテナのファイルシステムをreadonlyに
# -w(--workdir)=[pathname]: コンテナの作業ディレクトリを指定
# -u(--user)=[ユーザー名]: ユーザー名またはUIDを指定する
docker container run -it -e foo=bar centos /bin/bash

# attach: 起動中のコンテナに入れる。 ctrl+p ctrl+qで抜けられる。
# exec: 起動しているコンテナで、プロセスを実行。attachしても、入力を受け付けていない（サーバーが起動しているなど）ときに、使う
# -d(--detach): コマンドをバックグラウンド実行
# -i(--interactive): コンテナの標準入力を開く
# -t(--tty): 端末デバイスを使う
docker container exec -it webserver /bin/echo "Hello World"

# cp: ホストとコンテナでファイルのやり取りができる
# docker container cp コンテナ識別子:コンテナ内のファイルパス ホストのディレクトリパス
# docker container cp ホストのファイル コンテナ識別子:コンテナ内のディレクトリ
docker container cp webserver:/etc/nginx/nginx.conf /tmp/nginx.conf
docker container cp /tmp/nginx.conf webserver:/etc/nginx/nginx.conf

# diff: 現在のコンテナの状態と、containerイメージからの差分を確認できる。使えるのかな？
docker container diff webserver

# logsで、コンテナのログを確認可能
# -tで、タイムスタンプ表示
docker conatainer logs -t test1

# ls: container 一覧表示
# -aで、stopしているコンテナも表示
# --formatで、表示方法を指定できる。
docker container ls -a --format "{{.Names}}: {{.Status}}"

# port: コンテナで実行されているプロセスが転送されているポートを確認できる
docker container port webserver

# top: containerの実行プロセスの確認
# stats: containerの稼働状態の確認
docker container stats

# prune: 停止中の全てのcontainerを削除
docker container prune

# pause/unpause: コンテナの一時停止、再開
docker container test1 pause

# rename: container名を変更できる
docker container rename old new

# commit: コンテナからイメージを作成
# docker container commit コンテナ識別子 [イメージ名[:タグ名]]
# -a(--auther): 作成者を指定
# -m(--message): メッセージを指定する
# -c(--change): commit時のDockerfile名を指定（？）
docmer container commit -a "John Doe" webserver esksak/webfront:1.0