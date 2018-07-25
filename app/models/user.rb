class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                foreign_key: "follower_id",
                                dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                 foreign_key: "followed_id",
                                 dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  #バリデーションテストファイルで.valid?で呼び出せる。
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  #データベースに渡す前にメールアドレスを全て小文字にする。
  #データベースアダプタの中に大文字小文字を区別できないバカがいる。
  before_create :create_activation_digest
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, #存在することと長さ。
                    format: { with: VALID_EMAIL_REGEX }, #メールアドレスの表記に則っている
                    uniqueness: { case_sensitive: false } #大文字小文字の差を無視する
  has_secure_password #安全なパスワードを持っているぞ。
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true #パスワードがちゃんと存在して、長さの最小が6、編集の時だけからでも良い
  def User.digest(string)   ###今後テストなどでログインのパスワードを仮に発行したいときに用いる。
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにユーザー（記憶トークン）をデータベース（記憶ダイジェスト）に記憶する
  def remember
    self.remember_token = User.new_token   ###ハッシュ化した記憶トークンをremembe_token属性(インスタンス変数)に代入する。
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # (bcryptで暗号化して)渡された記憶トークンが記憶ダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest") # メタプログラミング
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)   ###記憶ダイジェストをnilにしてしまう。
  end

  # アカウントを有効にする
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # # アカウントを有効にする
  # def activate
  #   update_columns(activated: true, activated_at: Time.zone.now)
  # end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest:  User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # ユーザーのステータスフィードを返す
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end


  # ユーザーをフォローする
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  private

    # メールアドレスをすべて小文字にする
    def downcase_email
      email.downcase!
    end

    # 有効化トークンとダイジェストを作成および代入する
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
