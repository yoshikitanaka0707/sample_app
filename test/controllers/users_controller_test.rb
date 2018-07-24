require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "should redirect index when not logged in" do
    get users_path   ###ログインなしでindexに行ったら
    assert_redirected_to login_url   ###ログイんに課される
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)    ###編集ページに行ったら
    assert_not flash.empty?  ###フラッシュメッセージがからでないべきである。
    assert_redirected_to login_url   ###また、ログインページへリダイレクトされるべきである。
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)   ###権限のないユーザーでログイン
    assert_not @other_user.admin?   ###権限はあるべきでない。
    patch user_path(@other_user), params: {
                                    user: { password:              @other_user.password,
                                            password_confirmation: @other_user.password,
                                            admin: true } } #試しに管理者権限を与えて見ても
    assert_not @other_user.reload.admin?  ###やっぱり管理者権限は付与されているべきでない、
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user) ###間違ったユーザーでログインしたときに
    get edit_user_path(@user) ###正しいユーザーの情報編集ページに行ってみると
    assert flash.empty? ###フラッシュメッセージはからであるべきである。
    assert_redirected_to root_url ###ルートURLにリダイレクトされているべきである。
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end
end
