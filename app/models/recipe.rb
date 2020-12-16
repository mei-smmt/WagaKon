class Recipe < ApplicationRecord
  mount_uploader :image, ImageUploader

  # タイトル、画像、説明文必須
  validates :title, presence: true, length: { maximum: 20 }
  validates :image, presence: true
  validates :explanation, presence: true, length: { maximum: 400 }
  validates :status, presence: true
  
  # statusカラム設定
  enum status: { draft: 0, published: 1 }

  belongs_to :user
  has_one :feature
  has_many :ingredients, dependent: :destroy
  has_many :steps, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :menus, dependent: :destroy
  
  # レシピの公開、非公開設定
  def publishing
    self.update_attribute(:status, 1)
  end
  
  def drafting
    self.update_attribute(:status, 0)
  end

  # レシピ検索
  def self.search(search)   
    keywords = search.split(/[[:blank:]]+/)
    recipes = []
    
    keywords.each do |keyword|
      next if keyword == "" 
        recipes += Recipe.where(['title LIKE ? OR explanation LIKE ?', "%#{keyword}%", "%#{keyword}%"])   
      end 
    recipes.uniq
  end  
end
