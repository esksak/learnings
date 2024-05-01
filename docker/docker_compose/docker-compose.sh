# -fでdocker-composeファイルを指定できる（指定しない場合は./docker-compose.ymlを見に行く）
docker-compose -f docker-compose-base.yml

# up
# -d: バックグラウンド
# --no-deps: リンクのサービスを起動しない
# --build: イメージをビルドする
# --no-build: イメージをビルドしない
# -t(--timeout): コンテナのタイムアウトを秒指定（デフォルトは10秒）
# --scale サービスA=サービス数 --scale サービスB=サービス数 ...  サービスの数を指定

# up: 複数のサービスの生成
docker-compose up

# start/stop/restart/pause/unpause: サービス名を指定すると、特定のサービスのみに対しても実行可能
docker-compose stop

# run: 起動したコンテナで、任意のコマンドを実行できる。
docker-compose run server_a /bin/bash

# kill
docker-compose kill -s SIGINT

# logs: 連携しているコンテナのlogを一気に見られる
docker-compose logs

# ps: 連携しているコンテナを一覧で見る
docker-compose ps

# port: サービス公開用のポートの確認
docker-compose service_A port番号

# config: サービスの構成確認
docker-compose config

#rm（削除）
docker-compose rm

# down(削除) = stop + rm?
docker-compose down
