class User < ApplicationRecord
  mount_uploader :image, ImageUploader
  
  before_save { self.email.downcase! }
  validates :personal_id, presence: true, length: { in: 4..8 }, uniqueness: true
  validates :name, presence: true, length: { maximum: 20 }
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { in: 4..12 }
  
  has_many :recipes, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :favorite_recipes, through: :bookmarks, source: :recipe
  has_many :meals, dependent: :destroy
  
  def bookmark(recipe)
    self.bookmarks.find_or_create_by(recipe_id: recipe.id)
  end

  def unbookmark(recipe)
    bookmark = self.bookmarks.find_by(recipe_id: recipe.id)
    bookmark.destroy if bookmark
  end

  def favorite?(recipe)
    self.favorite_recipes.include?(recipe)
  end
  
end
