module SessionsHelper
  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  # ユーザーのセッションを永続的にする   ###HERE!!!
  def remember(user)
    user.remember    ###userクラスで定義したクラスメソッド
                     ###永続セッションのためにユーザー（記憶トークン）をデータベース（記憶ダイジェスト）に記憶する
    cookies.permanent.signed[:user_id] = user.id   ###コントローラーで記憶ダイジェストを永続化し認証する。
    cookies.permanent[:remember_token] = user.remember_token ###コントローラーで記憶トークンを永続化し認証する。
  end

  # 渡されたユーザーがログイン済みユーザーであればtrueを返す
  def current_user?(user)
    user == current_user
  end

  # 現在ログイン中のユーザーを返す (いる場合), 記憶トークンcookieに対応するユーザーを返す
  def current_user
    if (user_id = session[:user_id])    ###一時セッションをもつユーザーがいれば
      @current_user ||= User.find_by(id: user_id)    ###そのユーザーを返す
    elsif (user_id = cookies.signed[:user_id])    ####もしくは認証された永続cookieを持っているユーザーがいれば
      user = User.find_by(id: user_id)    ###データベースから該当するユーザーを探してきて
            if user && user.authenticated?(:remember, cookies[:remember_token]) ###もしそのユーザーの記憶ダイジェストと一致すれば
        log_in user   ###ログインして
        @current_user = user    ###そのユーザーを返す。
      end
    end
  end


  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end

  # 永続的セッションを破棄する
  def forget(user)
    user.forget    ###ユーザークラスで定義したforgetメソッドで記憶ダイジェストを削除する。
    cookies.delete(:user_id)    ###ユーザー情報のクッキーを削除する。
    cookies.delete(:remember_token)    ###記憶トークンのクッキーを削除する。
  end

  def log_out  #ログアウト用のメソッド
    forget(current_user)    ###上記で定義した、user.forgetメソッドでログインしているユーザーを削除する。
    session.delete(:user_id)
    @current_user = nil
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  # 記憶したURL (もしくはデフォルト値) にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # アクセスしようとしたURLを覚えておく
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
    #request.original_urlでリクエスト先が取得できます
  end
end
