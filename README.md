# アプリ概要
漢字を含む文章をひらがなに変換するアプリ。
詳細は[wiki](/../../wiki/アプリ概要)に記載。

# ビルド方法
環境
* Xcode 13.1.3
* Ruby 2.6.5
* Carthage 0.34.0

プロジェクトルートの `bootstrap.sh` を実行することでビルド可能な条件が揃う。

# 制限事項
各種APIに利用するキーは別途用意する必要がある。
* Yahooテキスト解析API  
https://developer.yahoo.co.jp/webapi/jlp/furigana/v1/furigana.html  
app_idを取得しなければひらがな変換できない。
取得したapp_idは以下に書き込むか、
`./HiraganaTranslator/supportingFiles/Secret.strings`  
もしくは、 `$HIRAGANA_TRANSLATOR_APP_ID` という環境変数にセットして  
`bootstrap.sh`を実行すれば良い。
ただし、StubサフィックスのSchemeを利用すれば実行可能。
テキスト変換は同じ文章が繰り返されるだけだがアプリの動作は確認できる。

* Firebase  
https://firebase.google.com/docs/ml-kit?hl=ja  
写真からテキスト解析が可能なMLKitを利用している。
リポジトリのplistはダミーである。
`./HiraganaTranslator/supportingFiles/GoogleService-Info.plist`
適宜差し替える必要がある。
ただし、StubサフィックスのSchemeを利用すれば実行可能。
テキスト解析は同じ文章が繰り返されるだけだがアプリの動作は確認できる。

* CI/CD  
bitriseでキャッシュが動作しない問題が発生しており、
現在はプロジェクトを無効化している。  
[#21](/../../issues/21)