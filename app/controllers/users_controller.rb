class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  #ログインしてても別のユーザーページに編集に行こうとしたら弾く。
  #アクション実行前にcorrect_userメソッドを実行し、
  #正しいユーザーがeditとupdateに行こうとすればルートurlにとばす。

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated?
  end

  def new
    @user = User.new
    # debugger
  end

  def create
    @user = User.new(user_params)  #strong parametersを使う。
    if @user.save #saveメソッドを使うまでバリデーションは働かない。
      # 保存の成功をここで扱う。
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'###保存が失敗したらnewページを出力（戻る）
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      # 更新に成功した場合を扱う。
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy   ###見つけて削除
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private #見えないようにできるやつ。セキュリティに関わるものはこの下に置く。

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # beforeアクション

    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location #アクセスしようとしたurlをおぼえて置く。
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
