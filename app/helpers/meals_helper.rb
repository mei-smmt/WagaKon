module MealsHelper
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
    week = ["日", "月", "火", "水", "木", "金", "土"]
    week[index]
  end
end
