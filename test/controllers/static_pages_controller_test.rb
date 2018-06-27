require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup #各テストが実行される直前で実行されるメソッド
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  test "should get home" do
    get root_path ###root_pathアクションをgetして
    assert_response :success ###正常に動作することを確認
    assert_select "title", "Home | #{@base_title}" #ついでに"title"の表記をチェック。
  end

  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title", "Help | #{@base_title}"
  end

  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", "About | #{@base_title}"
  end

  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "Contact | #{@base_title}"
  end
end
