module UsersHelper

  # 引数で与えられたユーザーのGravatar画像を返す
  def gravatar_for(user, options = { size: 80 })
  #キーワード引数でサイズを指定できるようにしている、なおデフォルトのサイズを指定している
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    #emailを直接指定するわけじゃなくて、ハッシュ化した状態で指定すると呼び出せる。
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
    #呼び出す時のGravatarの画像タグにgravatarクラスとユーザー名のaltテキストを追加したものを返すようにしている。
    # altテキストを追加しておくと、画像にテキストの説明が追加されるので視覚障害の人が見てもグッド。
  end
end
