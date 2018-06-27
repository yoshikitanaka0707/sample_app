module ApplicationHelper
    # ページごとの完全なタイトルを作って返しています。app/views/static_pagesにある奴らから引数を受け取って返している。
  def full_title(page_title = '') #page_titleは渡された引数。
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
end
