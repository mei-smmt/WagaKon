class Meal < ApplicationRecord
  validates :day_of_week, presence: true
  
  # day_of_weekカラム設定
  enum day_of_week: { sun: 0, mon: 1, tue: 2, wed: 3, thu: 4, fri: 5, sat: 6 }
  
  belongs_to :user
  has_many :munus, dependent: :destroy
end
