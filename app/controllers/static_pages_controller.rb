#/static_pages/homeというURLにアクセスすると、
#RailsはStaticPagesコントローラを参照し、homeアクションに記述されているコードを実行する。
class StaticPagesController < ApplicationController
  def home
  end

  def help
  end

  def about
  end
end
