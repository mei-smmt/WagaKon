module ApplicationHelper
  # スタートが今日の曜日になるループ
  def week_loop
    (0..6).each_with_object([]) do |n, week|
      week << Time.zone.now.since(n.days).wday
    end
  end

  def wday_jp(index)
    index == Time.zone.now.wday ? '今日' : I18n.t('date.day_names')[index]
  end

  def homepage_title(recipe)
    preview = link_preview(recipe.homepage)
    preview["title"].present? ? preview["title"] : truncate(recipe.homepage, length: 80)
  end

  def recipe_image(recipe)
    if recipe.image.present? || recipe.homepage.blank?
      recipe.image.to_s
    else
      preview = link_preview(recipe.homepage)
      preview["image"].present? ? preview["image"] : recipe.image.to_s
    end
  end

  def link_preview(page)
    key = ENV["LINK_PREVIEW_KEY"]
    target = page
    HTTParty.post("https://api.linkpreview.net?key=#{key}&q=#{target}")
  end
end
