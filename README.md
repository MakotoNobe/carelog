## 環境構築
### clone

```
$ git clone <url> && cd <repository-name>
```

### build project
```
$ docker-compose build
$ docker-compose run --rm front npm install // install node library
$ docker-compose run --rm back bin/rails db:create // create table
$ docker-compose run --rm back bin/rails db:migrate // db migration
```

### run app
```
$ docker-compose up
```

### open app
open app in browser
http://localhost:8080

### tips
```
$ docker-compose exec back bash // into api container
$ docker-compose exec back bin/rails c // rails console
$ docker-compose exec back bin/rails db:migrate // db migration
$ docker-compose exec back bin/rails db:reset // db reset
```

### サンプルデータ
```
$ docker-compose exec back bin/rails db:migrate:reset //migrationの再読み込み
$ docker-compose exec back bin/rails db:seed // 初期データ投入
```

### デバック
```
$ docker-compose up -d // バックグラウンドでdockerを起動
$ docker attach carelog_back_1 //pry-railsを実行
