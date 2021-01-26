# WagaKon
本やレシピサイトで見たレシピ、オリジナルレシピなどを登録し個人で管理するサイトです。  
承認済みの友だちとはレシピを共有することが可能です。
レシピから１週間分の献立を作成できます。  
<img width="1425" alt="WagaKon_PC" src="https://user-images.githubusercontent.com/69507322/105810293-0115e780-5fee-11eb-936d-380f3bca2d2b.png">

# URL
https://www.wagakon.com  
「テストログイン」ボタンを押すと、ワンクリックでログインできます。

# 使用技術
* Ruby 2.5.3
* Ruby on Rails 5.2.2
* MySQL 8.0
* Nginx
* Unicorn
* AWS
  * VPC
  * EC2
  * RDS
  * Route53
* Capistrano
* RSpec

# AWS構成
![AWS構成図画像](https://user-images.githubusercontent.com/69507322/105702288-eccedd80-5f4e-11eb-9383-255700aac195.png)


# 機能一覧
* ユーザー登録、ログイン機能
* レシピ投稿機能
  * 画像投稿(CarrierWave)
  * URLからページタイトル・画像を取得し表示(mechanize)
  * レシピのカテゴリ、材料・手順を登録
* 献立登録機能 
* お気に入り登録機能(Ajax)
* レシピ並び替え機能
  * 新しい順・古い順・お気に入りが多い順 
* レシピ検索機能
  * キーワード検索
  * レシピのカテゴリで絞込み検索
* 友達申請・承認機能
* ページネーション機能(kaminari)
* パンくずリスト(gretel)

# テスト
* RSpec
  * 単体テスト(model, controller) 
