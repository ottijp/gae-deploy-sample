#!/bin/bash -eu

# デプロイ対象のGitブランチ
GIT_BRANCH=${1:-master}
# app.yamlのパス
APP_CONFIG_FILE=${2:-app.yaml}
# gcloudコマンドのオプション
GCLOUD_OPTS=${@:3}

echo "GIT_BRANCH=${GIT_BRANCH}"
echo "APP_CONFIG_FILE=${APP_CONFIG_FILE}"
echo "GCLOUD_OPTS=${GCLOUD_OPTS}"

read -p "デプロイしてもよろしいですか？(y/N): " confirm
if [[ $confirm == [yY] ]]; then
  TEMP_DIR=`mktemp -d`
  echo "TEMP_DIR=$TEMP_DIR"

  # Gitブランチのエクスポート
  git archive --format=tar $GIT_BRANCH | tar -C $TEMP_DIR -xf -

  # app.yamlのコピー
  cp $APP_CONFIG_FILE $TEMP_DIR

  # ビルド
  cd $TEMP_DIR
  npm install
  npm run build

  # デプロイ
  gcloud app deploy $APP_CONFIG_FILE $GCLOUD_OPTS

  rm -r $TEMP_DIR
fi
