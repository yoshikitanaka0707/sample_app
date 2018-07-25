 require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup   #テスト用の有効な登録ユーザーを用意しておく。
    @user = users(:michael)
  end

  test "login with invalid information" do
    get login_path   ###login URLにgetリクエストが送信されると
    assert_template 'sessions/new'    ###sessions/newページが表示されるべきである。
    post login_path, params: { session: { email: "", password: "" } }    ###誤ったログインが行われると
    assert_template 'sessions/new'    ###同じページがrenderされるべきである。
    assert_not flash.empty?   ###その時フラッシュが空出ないべきである。
    get root_path   ###その後他のページに行くと。
    assert flash.empty?    ###フラッシュが空であるべきである。
  end

  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?  ###ログインできているべきである。
    assert_redirected_to @user   ###ログインが成功してリダイレクトした先が正しいかどうかをチェックしています。
    follow_redirect!   ###ログイン先まで行き、以下の通りリンクが存在しているか構造をチェックしている。
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path   ###ここからログアウト
    assert_not is_logged_in?   ###ログインできていないべきである。
    assert_redirected_to root_url
    # 2番目のウィンドウでログアウトをクリックするユーザーをシミュレートする
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: '1') ###三項演算子のフォームに合わせてログイン
    assert_not_empty cookies['remember_token']
  end

  test "login without remembering" do
    # クッキーを保存してログイン
    log_in_as(@user, remember_me: '1')
    delete logout_path
    # クッキーを削除してログイン
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end

end
