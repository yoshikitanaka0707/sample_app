require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get login_path  #名前付きルートに変更している。
    assert_response :success
  end

end
