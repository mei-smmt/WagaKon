module ApplicationHelper
  # スタートが今日の曜日になるループ
  def week_loop
    (0..6).each_with_object([]) do |n, week|
      week << Time.now.since(n.days).wday
    end
  end
  
  def wday_jp(index)
    index == Time.now.wday ? "今日" : I18n.t('date.day_names')[index]
  end
  
  def homepage_title(recipe)
    agent = Mechanize.new
    page = agent.get(recipe.homepage)
    if page.at('meta[property="og:title"]').present?
      page.at('meta[property="og:title"]')[:content]
    else
      recipe.homepage
    end
  end
  
  def homepage_image(recipe)
    if recipe.homepage.blank?
      false
    else
      agent = Mechanize.new
      page = agent.get(recipe.homepage)
      if page.at('meta[property="og:image"]').present?
        page.at('meta[property="og:image"]')[:content]
      else
        false
      end
    end
  end
end
