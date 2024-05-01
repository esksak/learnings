# create: 新しいネットワークの作成
# -d(--driver)=[ネットワークブリッジまたはオーバーレイ]
# --ip-range: コンテナに割り当てるIPアドレスのレンジを指定
# --subnet: サブネットをCIDRで指定
# --ipv6=true/false
# -label: label名
docker network create --driver=bridge web-network

# connect/disconnect: containerのネットワーク接続
# docker network [dis]connect ネットワーク名　コンテナ名
docker network connect web-network test1

# inspect: 詳細確認。Containersのプロパティんに、接続しているコンテナを一覧で確認できる
docker network inspect web-network

# rm : 削除
docker network rm web-network

# ls: networkの一覧
docker network ls