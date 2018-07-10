#/static_pages/homeというURLにアクセスすると、
#RailsはStaticPagesコントローラを参照し、homeアクションに記述されているコードを実行する。
class StaticPagesController < ApplicationController
#StaticPagesControllerはRubyのクラスだが
#ApplicationControllerクラスを継承しているため、
#StaticPagesControllerのメソッドは (たとえ何も書かれていなくても)
#Rails特有の振る舞いをします。
#具体的には、/static_pages/homeというURLにアクセスすると、
#RailsはStaticPagesコントローラを参照し、homeアクションに記述されているコードを実行します。
#その後、そのアクションに対応するビューを出力します。  
  def home
  end

  def help
  end

  def about
  end
end
