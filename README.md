## 環境構築
### clone

```
$ git clone <url> && cd <repository-name>
$ yarn install // HaskyをInstallし、コミット時にLintを流します。
```

### build project
```
$ docker-compose build
$ docker-compose run --rm app yarn install // install node library
$ docker-compose run --rm api bin/rails db:create // create table
$ docker-compose run --rm api bin/rails db:migrate // db migration
```

### run app
```
$ docker-compose up
```

### open app
open app in browser
http://localhost:4000

### tips
```
$ docker-compose exec app ash // into app container
$ docker-compose exec app yarn test // テスト
$ docker-compose exec app yarn lint // 解析
$ docker-compose exec app yarn lintfix // 自動修正
$ docker-compose exec api rubocop -A // 自動修正
$ docker-compose exec api bash // into api container
$ docker-compose exec api bin/rails c // rails console
$ docker-compose exec api bin/rails db:migrate // db migration
$ docker-compose exec api bin/rails db:reset // db reset
```

### サンプルデータ
```
$ docker-compose exec api bin/rails db:migrate:reset //migrationの再読み込み
$ docker-compose exec api bin/rails db:seed // 初期データ投入
$ docker-compose exec api bin/rails sample:db // サンプルデータ投入
$ docker-compose exec api bin/rails seed:create_address //CSVから住所情報をDBに保存する
```

### スクレイピング
```
$ docker-compose exec api bin/rails runner lib/batch/crawler.rb //クローラーを動かす
```

### デバック
```
$ docker-compose up -d // バックグラウンドでdockerを起動
$ docker attach home_care_navi_api_1 //pry-railsを実行