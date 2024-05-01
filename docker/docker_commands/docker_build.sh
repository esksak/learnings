# Dockerfileからイメージの作成
# -fで、Dockerファイルの名前を指定もできる(デフォルトはDockerfile）
# docker build -t [生成するイメージ名]:[タグ名] [Dockerfileの場所]
docker build -t sample -f Dockerfile ../docker_file

# docker history イメージを生成するときにどのようなコマンドを実行されたかをかくにんできる
docker history sample