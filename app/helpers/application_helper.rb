module ApplicationHelper
  def week_loop
    week = []
    day = Time.now.wday
    7.times do
      week << day
      day = (day == 6) ? 0 : (day + 1)
    end
    week
  end
  
  def wday_jp(index)
    week = ["日曜日", "月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日"]
    if index == Time.now.wday
      return "今日"
    else
      return week[index]
    end
  end
end
