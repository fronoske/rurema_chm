## 最新のるりまドキュメントからchmをビルドする / Build chm for latest rurema document

実行環境
- Windows

必要なツール
- ruby
- bundler
- git
- HTML Help Work Shop

### 環境を準備
```
> mkdir rurema
> cd rurema
```

### arairait版bitclust レポジトリをclone（すでにレポジトリがあれば pull）
```
> git clone https://github.com/arairait/bitclust.git
または
> cd bitclust
> git pull
```

### 本家bitclustのコミットをマージしてpush（他の人は不要）
```
> git remote add upstream https://github.com/rurema/bitclust.git
> git fetch upstream
> git merge upstream/master
> git push
```

★arairait版はTOCの修正のため本家から lib\bitclust\subcommands\chm_command.rb を加工している（巻末を参照）

### ドキュメントデータを取得
```
元のディレクトリに戻り
> git clone https://github.com/rurema/doctree.git rubydoc
```

### gemsをインストール
```
> bundle install --path=vendor/bundle
```

### DB生成
```
> bundle exec bitclust -d ./db init encoding=utf-8 version=2.6.3
> bundle exec bitclust -d ./db update --stdlibtree=./rubydoc/refm/api/src
（"singleton object class not implemented yet" というワーニングが出るが無視）
```

### chm 素材作成
```
> if exist chm rmdir /S /Q chm
> bundle exec bitclust -d ./db chm -o ./chm
```

### Windows で HWS 実行
```
> "C:\Program Files (x86)\HTML Help Workshop\hhc.exe" chm\refm.hhp
```


### （備考）refm.hhcへのパッチ
- chm/doc/index.html にもとづいて refm.hhc を出力する

- index.html のためのルートノードを用意する
- index.html にあるリンクをノードとして出力する
- 「Ruby 言語仕様」>「その他」は抜いてダイレクトに
- 組み込みライブラリ、標準添付ライブラリの子ノードとして現状を差し込む
-- ただし Errorno::* は除外
-- 「このリファレンスマニュアルについて」を差し込む
- CAPI は index.html から除外

- TODO: ツリーのトップに「Ruby 2.x.x リファレンスマニュアル」を設置したい
