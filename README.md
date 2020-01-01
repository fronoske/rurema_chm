## 最新のるりまドキュメントからchmをビルドする / Build chm for latest rurema document

### 実行環境
OS
- Windows

必要なツール
- ruby
- bundler
- git
- HTML Help Work Shop

### 環境を準備
```
> git clone https://github.com/arairait/rurema_chm
> cd rurema_chm
```

### arairait版bitclust レポジトリをclone（すでにレポジトリがあればpull）

arairait版はTOCの修正のため本家から lib\bitclust\subcommands\chm_command.rb を加工している（巻末を参照）

```
(current dir: rurema_chm)
> git clone https://github.com/arairait/bitclust.git
> cd bitclust
またはすでに clone していれば
> cd bitclust
> git pull
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

### ドキュメントデータを取得
```
(current dir: 変わらず rurema_chm/bitclust)
> git clone https://github.com/rurema/doctree.git rubydoc
```

### gemsをインストール
```
(current dir: 変わらず rurema_chm/bitclust)
> bundle install --path=vendor/bundle
```

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
