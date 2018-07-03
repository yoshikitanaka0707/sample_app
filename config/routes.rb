#StaticPagesコントローラを生成すると、(config/routes.rb)ファイルが自動的に更新される。
#このルーティングファイルはルーターの実装を受け持ち、URLとWebページの対応関係を定義する。
Rails.application.routes.draw do
  get 'users/new'
  get 'users/new' #users/newというURLに対してgetリクエストが来たら、StaticPagesコントローラのnewアクションに渡すよう
  root 'static_pages#home' #ルート「/」へのGETリクエストがStaticPagesコントローラのhomeアクションにルーティングされます。
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/signup',  to: 'users#new'
end
