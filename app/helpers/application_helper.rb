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
    agent = Mechanize.new
    failure_value = truncate(recipe.homepage, length: 80)
    scrape(recipe, agent, 'meta[property="og:title"]', failure_value)
  end

  def homepage_image(recipe)
    if recipe.homepage.blank?
      false
    else
      agent = Mechanize.new
      scrape(recipe, agent, 'meta[property="og:image"]', false)
    end
  end

  def scrape(recipe, agent, meta, failure_value)
    page = agent.get(recipe.homepage)
    if page.at(meta).present?
      page.at(meta)[:content]
    else
      failure_value
    end
  rescue Mechanize::ResponseCodeError
    failure_value
  end
end
