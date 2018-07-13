#User用テスト
require 'test_helper'
  class UserTest < ActiveSupport::TestCase

    def setup #setupメソッド、この中に書かれた処理は他のtestが入る前に実行される。
      @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
    end

    test "should be valid" do
      assert @user.valid? #ちゃんとインスタンスができているか？ちゃんとUser.newできてますか？
    end

    test "name should be present" do
      @user.name = "     " #あえて失敗させる
      assert_not @user.valid?
      #有効でないよね?ちゃんとバリデーションを書いていて、その条件に当てはまっていなければtrue。
    end

    test "name should not be too long" do
      @user.name = "a" * 51 #あえて失敗させる
      assert_not @user.valid?
      #有効でないよね?ちゃんとバリデーションを書いていて、その条件に当てはまっていなければtrue。
    end

    test "email should not be too long" do
      @user.email = "a" * 244 + "@example.com" #あえて失敗させる
      assert_not @user.valid?
      #有効でないよね?ちゃんとバリデーションを書いていて、その条件に当てはまっていなければtrue。
    end

    test "email validation should reject invalid addresses" do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                             foo@bar_baz.com foo@bar+baz.com]
                             #あえて失敗させる
      invalid_addresses.each do |invalid_address|
        @user.email = invalid_address
        assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
      end
      #有効でないよね?ちゃんとバリデーションを書いていて、その条件に当てはまっていなければtrue。
    end

    test "email addresses should be unique" do
      duplicate_user = @user.dup
      @user.save
      assert_not duplicate_user.valid?
    end

    test "email addresses should be saved as lower-case" do
      mixed_case_email = "Foo@ExAMPle.CoM" #大文字を小文字にできていないやつを使う。
      @user.email = mixed_case_email
      @user.save
      assert_equal mixed_case_email.downcase, @user.reload.email #ちゃんとエラー吐いてるぜ！
    end

    test "password should be present (nonblank)" do
      @user.password = @user.password_confirmation = " " * 6 #パスワードが存在しない婆愛。
      assert_not @user.valid?
    end

    test "password should have a minimum length" do
      @user.password = @user.password_confirmation = "a" * 5 #パスワードが５文字以下の場合・
      assert_not @user.valid?
    end

  end
