require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get signup_path   #signupページに行く
    assert_no_difference 'User.count' do
      #間違ったフォーム入力後にユーザー登録数が変わらないことを確かめる。
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new' #sinup_pathを参照したときにuser/newテンプレートが参照されているべきである。
    assert_select "div#error_explanation" #パーシャルの中に記述されてあるcssが表示されているかで、エラーメッセージが表示されているか確認する。この場合idがあるかで見ている。
    assert_select "div.field_with_errors" #無効な内容が送信されたときにページが元に戻されたときに生成されるクラスがちゃんとあるかで調べている。
  end

  test "valid signup information" do
  get signup_path
  assert_difference 'User.count', 1 do
    post users_path, params: { user: { name:  "Example User",
                                       email: "user@example.com",
                                       password:              "password",
                                       password_confirmation: "password" } }
  end
  follow_redirect!
  assert_template 'users/show'
  assert_not flash.empty?
end
end
