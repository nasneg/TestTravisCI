#!/bin/bash

# ソースコード生成処理
# 以下の環境変数を設定
# GET_FILE_BRANCH：ファイル取得してくるブランチ
# APP_DEVELOP_BRANCH：アプリの開発ブランチ

# if [[ $TRAVIS_EVENT_TYPE = "api" ]] ; then
    # API経由での起動の場合に自動でソースを生成してPRを送る

    # ファイルの取得
    echo "=== start file get ==="
    ./.travis_scripts/get_github_file.sh \
    nasneg \
    FilePut \
    $GET_FILE_BRANCH \
    docs/file/test/time.txt \
    ./docs/time.txt
    # 正常終了チェック
    if [ $? -ne 0 ]; then
        exit 1
    fi

    # ソース生成
    echo "=== start source generate ==="
    mkdir -p ./docs/generate/
    cp ./docs/time.txt ./docs/generate/time.txt
    `date "+%Y-%m-%d_%H-%M-%S"` > ./docs/generate/date.txt
    cat ./docs/generate/*

    # PRの生成
    echo "=== start create pull request ==="
    ./.travis_scripts/create_pr.sh \
    PRTarget \
    $APP_DEVELOP_BRANCH \
    ./docs/generate \
    ./src/docs/generate
    # 正常終了チェック
    if [ $? -ne 0 ]; then
        exit 1
    fi
# fi
