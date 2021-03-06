#!/bin/bash

# PullRequestの生成処理
# 以下の環境変数を追加する
# GH_TOKEN
# GH_USER
#
# 第１引数：リポジトリ名
# 第２引数：ブランチ名
# 第３引数：コピー元フォルダ
# 第４引数：コピー先フォルダ

BRANCH_PREFIX="auto_generate_pr_"
HUB_VERSION="2.2.9"

# 認証情報を設定する
mkdir -p "$HOME/.config"
set +x
echo "https://${GH_TOKEN}:@github.com" > "$HOME/.config/git-credential"
echo "github.com:
- oauth_token: ${GH_TOKEN}
user: ${GH_USER}" > "$HOME/.config/hub"
unset GH_TOKEN
set -x

# Gitを設定する
git config --global user.name  "${GH_USER}"
git config --global user.email "${GH_USER}@users.noreply.github.com"
git config --global hub.protocol "https"
git config --global credential.helper "store --file=$HOME/.config/git-credential"

# hubをインストールする
curl -LO "https://github.com/github/hub/releases/download/v${HUB_VERSION}/hub-linux-amd64-${HUB_VERSION}.tar.gz"
tar -C "$HOME" -zxf "hub-linux-amd64-${HUB_VERSION}.tar.gz"
export PATH="$PATH:$HOME/hub-linux-amd64-${HUB_VERSION}"

# リポジトリに変更をコミットする
hub clone -b "${2}" ${1}" _
cd _
NEW_BRANCH_NAME=${BRANCH_PREFIX}`date "+%Y-%m-%d_%H-%M-%S"`
hub checkout -b ${NEW_BRANCH_NAME}
## ファイルを変更する ##
mkdir -p ${4}
rm -r ${4}
cp -rp ../${3} ${4}
hub add .
hub commit -m "[UPDATE File] ${NEW_BRANCH_NAME}"
if [ $? = 0 ] ; then
    # Pull Requestを送る
    hub push origin $BRANCH_NAME
    hub pull-request -m "[AUTO PR] ${NEW_BRANCH_NAME}"
else
    echo "There no updates"
fi

cd ..