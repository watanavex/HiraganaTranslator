#!/bin/zsh

######## gem ########
bundle install

######## cocoapods ########
bundle exec pod install || bundle exec pod install --repo-update

######## carthage ########
carthage bootstrap --platform iOS --cache-builds

# for Cuckoo
# 実行ファイルのダウンロードスクリプトがgithubのアクセストークンを適用出来ない
# 参考: https://github.com/Brightify/Cuckoo/pull/255
cd ./Carthage/Checkouts/Cuckoo/
if [[ ! -z "$GITHUB_ACCESS_TOKEN" ]]; then
    REQUEST_HEADER="-H 'Authorization: token ${GITHUB_ACCESS_TOKEN}'"
fi
FILE_NAME="cuckoo_generator"
URL="https://api.github.com/repos/Brightify/Cuckoo/releases/tags/1.1.1"
DOWNLOAD_URL=$(eval curl $REQUEST_HEADER "$URL" | grep -oe '"browser_download_url":\s*"[^" ]*"' | grep -oe 'http[^" ]*' | grep ${FILE_NAME} | head -1)
echo $DOWNLOAD_URL
eval curl -Lo "${FILE_NAME}" "$DOWNLOAD_URL"
chmod +x "$FILE_NAME"

cd $OLDPWD

######## Secret ########
AppID="\"AppId\" = \"$HIRAGANA_TRANSLATOR_APP_ID\";"
StringsFile=./HiraganaTranslator/supportingFiles/Secret.strings
echo $AppID > $StringsFile