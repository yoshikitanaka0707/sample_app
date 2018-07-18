class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])#だいたいコントローラでdbから引っ張ってくる。
    # debugger
    #gem byebugによるメソッド書いてrails -sするとそのターミナル上で
    #Railsコンソールのようにコマンドを呼び出すことができる。
  end

  def new
    @user = User.new
    # debugger
  end

  def create
    @user = User.new(user_params)  #strong parametersを使う。
    if @user.save #saveメソッドを使うまでバリデーションは働かない。
      # 保存の成功をここで扱う。
      log_in @user   ###ユーザー登録と同時にログインさせる。
      flash[:success] = "Welcome to the Sample App!"   ###一度だけフラッシュメッセージを表示する。
      redirect_to @user   #redirect_to user_url(@user)
    else
      render 'new'###保存が失敗したらnewページを出力（戻る）
    end
  end

  private #見えないようにできるやつ。

    def user_params   #こいつらだけ書き換えて良いぞ。
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
