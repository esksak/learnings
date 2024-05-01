# fromでベースイメージを指定
FROM ununtu:16.04

# RUNコマンド（Dockerは１コマンドごとに中間イメージを作るので、できるかぎりまとめたほうが良い）
# shell形式での実行（内部的には、/bin/sh -cが使われる）
RUN apt-get install -y nginx

# exec形式では、/bin/shを介さずに直接実行。Docker推奨はexec形式。
# JSON配列で指定できる。ただし、コマンド引数に環境変数を指定できない
# RUN ["/bin/bash", "-c", "apt-get install -y nginx"]

# CMD命令： イメージを元に生成したコンテナ内で実行するコマンド
# Dockerfileにつき、１つだけ実行できる。複数指定の場合は、最後のものが実行される

# Exec形式
CMD ["nginx", "-g", "daemon off"]

# Shell 形式（/bin/sh -cを介して実行）
# CMD nginx -g 'daemon off'

# ENTRYPOINT命令：Dockerfileからビルドしたイメージから
# コンテナをdocker container runで起動する際に実行される

# Exec形式
ENTRYPOINT [ "nginx", "-g", "daemon off;" ]

# Shell形式
# ENTRYPOINT nginx -g 'daemon off;'


# ENTRYPOINT命令とCMD命令の違い
# どちらもコンテナ起動時に実行されるコマンドを指定するものだが、
# CMD命令は、docker container runの引数で上書きでき、ENTRYPOINTは上書きできない
# ENTRYPOINT命令とCMD命令を組み合わせて、オプションだけをdocker container runから指定できるような形にもできる

# "docker container run -it sample -d 2"とすると、オプションパラメーターを更新できる
# ENTRYPOINT ["top"]
# CMD ["-d", "10"]

# ONBUILD命令：自身のDockerfileから生成したイメージをベースイメージとした、
# 別のDockerfileをビルドする際に実行させたいコマンドを記述する。
# ベースイメージはインフラの構成のみを指定して、アプリケーションのビルドに関するところは、別のイメージで行う、みたいなことができるらしい
# ただ、その２つは密に連携することになりそうなので、管理上の意味以上のことはなさそう？
# ちなみに、onbuildが指定されているイメージかどうかは、docker image inspect  --format="{{ .Config.OnBuild }}" イメージ名で確認できる

# fromでこのイメージが指定された時のみ実行される
ONBUILD ADD website.tar /var/www/html/ 

# STOPSIGNAL命令：コンテナを修了するときに送信するシグナルを指定できる。（SIGKILLなど）
STOPSIGNAL SIGKILL

# HEALTHCHECK命令：コンテナの正常性をどのように確認するかを指定する
# ヘルスチェック結果は、docker container inspectの、Healthプロパティから確認できる

# ５分ごとに稼働中のWebサーバーのメインページを3秒以内に表示できるかをヘルスチェックとする
HEALTHCHECK --interval=5m --timeout=3s CMD curl -f http://localhost/ || exit 1

# ENV命令：環境変数の設定
# docker container run --envオプションで上書きできる
# 一つ指定する場合（複数行にもできるが、イメージがその度に作られるので、複数指定する場合は↓にする）
ENV foo bar

# 複数指定する場合 (=をつける)
# ENV foo=bar hoge=fuga baz=foobar

# WORKDIR命令：RUN/CMD/ENTRYPOINT/COPY/ADD命令を実行するディレクトリを指定できる
# abs/rel pathが使え、環境変数も使える

# 最終的なworkdirは/first/second/third
ENV DIRPATH /first
WORKDIR ${DIRPATH}
WORKDIR second
WORKDIR third

# USER命令：実行するユーザーを指定（事前にユーザーを作っておく必要がある）
RUN ["adduser", "john"]
USER john

# LABEL命令：イメージのバージョンや作成者情報やコメントなどの情報を持たせる際に利用
# docker image inspect --format={{ .Config.Labels }}
LABEL title="test" version="1.0" description="sample test"

# EXPOSE命令：公開ポートの指定
EXPOSE 8080

# ARG命令：環境変数とは異なり、Dockerfile内でのみ利用する変数
# docker-build -t時に、--build-argで指定可能
ARG ARG1="hoge"
RUN echo ${ARG1}

# SHELL命令：デフォルトシェルを変更できる
SHELL ["/bin/bash", "-c"]

# ADD命令：ファイル・ディレクトリの追加
# .dockerignore ファイルをDockerfileと同じディレクトリに配置しておくと、不要なファイルをインクルードしなくなる。
# docker buildコマンドは、Dockerfileを含むディレクトリをすべてDockerデーモンに転送してしまう
ADD host.html /docker_dir

# COPY命令：ADD命令と似ている。ADD命令は、リモートファイルのダウンロードやアーカイブの解答もしてくれるが、COPYはただコピーするだけ

# VOLUME命令：イメージにボリュームを割り当てる
# コンテナの内部に永続データは持てないので、コンテナ外のストレージ（ホストマシン上のボリュームや共有ストレージ）をマウントするように設定できる
# （？）
# VOLUME ["/マウントポイント"]
