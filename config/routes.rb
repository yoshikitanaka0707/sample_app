#StaticPagesコントローラを生成すると、(config/routes.rb)ファイルが自動的に更新される。
#このルーティングファイルはルーターの実装を受け持ち、URLとWebページの対応関係を定義する。
Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  root 'static_pages#home' #ルート「/」へのGETリクエストがStaticPagesコントローラのhomeアクションにルーティングされます。
  get 'users/new' #users/newというURLに対してgetリクエストが来たら、StaticPagesコントローラのnewアクションに渡すよう
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'   ###postリクエストが/signup URLに送られたときに、users#createアクションに飛ばす。
  get    '/login',   to: 'sessions#new'   ###ログインフォーム送信
  post   '/login',   to: 'sessions#create'   ###ログイン
  delete '/logout',  to: 'sessions#destroy'   ###ログアウト
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
end
