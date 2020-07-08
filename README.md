## 最新のるりまドキュメントからchmをビルドする / Build chm for latest rurema document

> Github Actionsによって毎月定期的にCHMビルドしてこのリポジトリに置くようにしました。\
> 生成したCHMはReleasesからダウンロードできます。 

### 実行環境
OS
- Windows

必要なツール
- ruby
- bundler
- git
- HTML Help Work Shop

## 初めての場合

### 環境を準備
```
> git clone https://github.com/fronoske/rurema_chm
> cd rurema_chm
```

### fronoske版bitclust レポジトリをclone
fronoske版はTOCの修正のため本家から lib\bitclust\subcommands\chm_command.rb を加工している（巻末を参照）

```
(current dir: rurema_chm)
> git clone https://github.com/fronoske/bitclust.git
> cd bitclust
```

### 本家bitclustのコミットをマージ
```
(current dir: rurema_chm/bitclust)
> git remote add upstream https://github.com/rurema/bitclust.git
> git fetch upstream
> git merge upstream/master
```

### push（本リポジトリの開発者のみ。他の人は不要）
```
> git push
```

### ドキュメントデータを本家から取得
```
(current dir: 変わらず rurema_chm/bitclust)
> git clone https://github.com/rurema/doctree.git rubydoc
```

### gemsをインストール
```
(current dir: 変わらず rurema_chm/bitclust)
> bundle install --path=vendor/bundle
```

## 2回め以降
リポジトリのupdateのみでOK
```
rurema_chm> git pull
rurema_chm> cd bitclust
rurema_chm\bitclust> git pull
rurema_chm\bitclust> git fetch upstream
rurema_chm\bitclust> git merge upstream/master
rurema_chm\bitclust> cd rubydoc
rurema_chm\bitclust\rubydoc> git pull
rurema_chm\bitclust\rubydoc> cd ..
rurema_chm\bitclust>
```

## CHM生成
これ以降は毎回実行する

### DB生成
```
(current dir: 変わらず rurema_chm/bitclust)
> bundle exec bitclust -d ./db init encoding=utf-8 version=2.7.0
> bundle exec bitclust -d ./db update --stdlibtree=./rubydoc/refm/api/src
（"singleton object class not implemented yet" というワーニングが出るが無視してOK）
```
これは少し時間がかかる

### chm 素材作成
```
(current dir: 変わらず rurema_chm/bitclust)
> if exist chm rmdir /S /Q chm
> bundle exec bitclust -d ./db chm -o ./chm
```
これもまあまあ時間がかかる

### Windows で HWS 実行
```
(current dir: 変わらず rurema_chm/bitclust)
> "C:\Program Files (x86)\HTML Help Workshop\hhc.exe" chm\refm.hhp
```

### 【備考】refm.hhcへのパッチ内容
- chm/doc/index.html にもとづいて refm.hhc を出力する

- index.html のためのルートノードを用意する
- index.html にあるリンクをノードとして出力する
- 「Ruby 言語仕様」>「その他」は抜いてダイレクトに
- 組み込みライブラリ、標準添付ライブラリの子ノードとして現状を差し込む
  - ただし Errorno::* は除外
  - 「このリファレンスマニュアルについて」を差し込む
- CAPI は index.html から除外

### TODO
- ツリーのトップに「Ruby 2.x.x リファレンスマニュアル」を設置したい
- TOC から Errorno::* をなくしたい
- 今の[るりま](https://docs.ruby-lang.org/ja/latest/class/Array.html) のようにページ先頭に目次を置きたい
