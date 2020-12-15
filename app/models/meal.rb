class Meal < ApplicationRecord
  validates :day_of_week, presence: true
  
  # day_of_weekカラム設定
  enum day_of_week: { sun: 0, mon: 1, tue: 2, wed: 3, thu: 4, fri: 5, sat: 6 }
  
  belongs_to :user
  has_many :menus, dependent: :destroy
  has_many :menu_recipes, through: :menus, source: :recipe
  
  scope :day, -> (wday) { find_by(day_of_week: (wday)) }

  def add_to_meal(recipe)
    self.menus.find_or_create_by(recipe_id: recipe.id)
  end

  def remove_frome_meal(recipe)
    menu = self.menus.find_by(recipe_id: recipe.id)
    menu.destroy if menu
  end
end
