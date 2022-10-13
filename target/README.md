# TARGET チェック種牡馬リストカスタマイズツール

## 概要

TARGET Frontier JVで使用するチェック種牡馬リストは、独自のフォーマット＆1ファイルにすべての情報が書かれており、カスタマイズがとてもやりにくい。
そこで、

- サイアーラインごとにわけて管理できる
- YAMLで記述できる
- チェック種牡馬リストのフォーマットに出力できる

ようにしたものです。

本ツールは[MITライセンス](https://github.com/kun432/keiba-tools/blob/main/LICENSE)の元、リリースされています。

## 必要なもの

- Perl
  - File::Basename
  - YAML::XS

参考までに確認している環境は以下

- macOS-12.5.1
- perl-5.34（homebrewでインストールしたものを使用）

## ツールの内容

```bash
$ tree .
.
├── README.md
├── ketto2yaml.pl
├── yaml2ketto.pl
├── cleanup.sh
├── output/
└── work/
```

- ketto2yaml.pl
  - チェック種牡馬リストファイルを読み込んで、サイアーラインごとのYAMLファイルをworkディレクトリに出力
- ketto2yaml.pl
  - workディレクトリのYAMLファイルを読み込んで、チェック種牡馬リストファイルをoutputディレクトリに出力
- cleanup.sh
  - workディレクトリ、outputディレクトリ以下のファイルを削除する
  - 通常は使用しない。1からチェック種牡馬リストファイルを作り直したい場合などに使う

## 使い方

TARGETのインストールディレクトリ（通常C:¥TJFV）にあるCHECKKETTO.LSTを持ってきてketto2yaml.plに食わせる

```bash
$ ./ketto2yaml.pl CheckKetto.LST
```

workディレクトリに出力される

```bash
$ ls work
01.yml  04.yml  07.yml
02.yml  05.yml  08.yml
03.yml  06.yml  09.yml
```

各YAMLはこんな感じになっているので、好みに合わせて、

- サイヤーライン名を修正したり
- サイヤーラインの色を変えたり
- サイヤーラインに新種牡馬を追加したり
- 新しいサイヤーライン用のファイルを追加したり

すればよい

```yaml
---
color: FFFF00
name: Lyphard系
sires:
- Al Nasr
- Alzao
- Apollo
- Au Point
- Bellypha
(snip)
```

YAMLを修正したらチェック種牡馬リストファイルを出力する。outputディレクトリに"CheckKetto_Custom.LST"というファイル名で出力される。

```bash
$ ./yaml2ketto.pl
```

TARGETのディレクトリに持っていって、環境設定から変更すればOKです。
## その他

- デフォルトのCHECKKETTO.LSTファイルは念の為バックアップしておくことをおすすめします。
