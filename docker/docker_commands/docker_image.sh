#!/bin/zsh
# docker image

# DCT (Docker Content Trust): imageの正当性を検証する仕組みを有効化する
export DOCKER_CONTENT_TRUST=1

# pull
# :7はタグ名。省略すると、:latestとみなされる
docker image pull centos:7

# -a cent osで、すべてのtagのイメージを取得
docker image pull -a centos

# 現在取得しているimageの一覧
docker image ls

# inspectで詳細情報を確認可能。結果はjsonで取得できる。
# --format optionを使うことで、特定のプロパティのみを取得できる
docker inspect centos:7 --format "{{ .ContainerConfig.Image }}"

# 既存のイメージに、新しくtagをつけることができる。あくまで、ただのtagづけ。git tagみたいなもの。
# Docker hubに上げることを考えると、[user name]/[image name]:[tag name]のフォーマットにしておくのがよい
docker image tag centos:7 esksak/myfirst_image:1.0

# docker searchで、公開されているimageの検索
docker search nginx  --filter=stars=1000

# imageの削除 [image名:tag名]か、image idを指定する
docker image rm centos:7

# docker hubへのログイン
docker login

# docker imageのpush。tag名は省略可能
docker image push esksak/myfirst_image:1.0

# docker hubからのログアウト
docker logout

# docker imageのsave
docker image save -o 保存ファイル名 [イメージ名]

# docker image saveで保存したものを展開 
#（docker image importは、docker container exportに呼応するようになっているので、使えない）
docker image load -i ファイル名