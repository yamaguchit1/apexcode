# 初めに
mainブランチが本体です。
これはSalesforceのAPEXソースをバージョン管理するためだけのものです。
githubとSalesforceは連携してません。本番へのリリースはsandbox⇒本番環境のデプロイ機能を使って行います。

まずはVSCodeに拡張機能を入れてください。
- Salesforec Exentionpack

## 開発開始ーデプロイの方法は以下
- 開発用Sandboxを作成
- リモートリポジトリからクローン
- 開発用branchを切る、命名は[featuer-○○]※新機能系　[hotfix-○○] ※バグ系　○○の部分は適当に機能名とかバグの内容とか　
- VSCode上でSalesforce認証を通す
- 新規APEXクラスが出来たら、package.xmlも整理しておく
- 開発作業進めて、完了。テストカバレッジもOK。
- ここまでコミットを適当にしておく。
- 本番にリリースする。
- バグ修正する。コミットする。
- プルリクエストを作って、全部mainに反映させる。
  

## 設定が必要

- 確認中

## Read All About It
- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)
