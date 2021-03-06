## ポートフォリオCRMシステム

**◆なぜ作ったのか**

自社内で使用する業務システムをフルスクラッチで開発できるDXエンジニアになるためです。
前職ではSalesforceやHubspotの管理者と基幹システムの保守を担当していたのですが、常に問題となっていたのが
1. UIが使いづらい
2. 他のシステムとデータの連携ができない
ということでした。

1の問題を解決するためにUIの向上を試みたのですが、
SalesforceのUIはローコード開発が基本であるためコードを用いた開発よりも限定的なことしかできず、痒いところに手が届かず現場メンバーの求めるUIの開発ができませんでした。
基幹システムはGoogle apps scriptで書かれていたため、UIはスプレッドシートやGoogleフォームを編集することしかできず、こちらも現場メンバーの求めるUIの開発ができませんでした。他にnocodeで開発できるツールをいくつか検討しましたが、やはり上記の２件と同様にUIの開発の自由度が低いという問題がありました。
UIを自由に開発するためには結局WEBフレームワークを用いて開発する他ないという結論に至りました。

2の問題を解決するために他のシステムとのデータ連携を試みたのですが、
既成のシステムの使用可能なAPIは開発元の開発方針に依存せざるを得ず、自社が欲しいデータが得られない、APIの仕様に関する情報が十分に見つからず上手に活用できないというジレンマがありました。業務フローの中に既成のシステムが組み込まれていればいるほどデータの連携のしづらく、また複雑になってしまっていました。
この問題を解決するにはデータの流れの中に自前で開発したデータの箱を用意してそこをハブとしてデータ連携を行うしかないのではないかという結論に至りました。

また一般に既成のシステムはOSSを用いた開発に比べてライセンス料が高くため、システムにかかるコストが割高になってしまいます。Salesforceは特に高額なライセンス料がかかることが知られているため、内省化することで大きなコスト削減につながります。

これらの問題を解決するために、私が自社内で使用する業務システムをフルスクラッチで開発できるDXエンジニアになるしかないと決意しました。