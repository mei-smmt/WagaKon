class Recipe < ApplicationRecord
  mount_uploader :image, ImageUploader

  # レシピのタイトル、説明文必須
  validates :title, presence: true, length: { maximum: 20 }
  validates :explanation, presence: true, length: { maximum: 60 }
  validates :size, length: { maximum: 10 }
  validates :homepage, url: { allow_nil: true, allow_blank: true }
  validates :status, presence: true
  
  # statusカラム設定
  enum status: { draft: 0, published: 1 }

  belongs_to :user
  has_one :feature, dependent: :destroy
  accepts_nested_attributes_for :feature
  has_many :ingredients, dependent: :destroy
  has_many :steps, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :menus, dependent: :destroy
  
  #レシピの変更後属性を割り当て
  def replace_attributes(recipe_params)
    self.assign_attributes(recipe_params.except(:remove_img))
    self.remove_image! if recipe_params[:remove_img] == "1"
  end
  
  # レシピの公開、非公開
  def publishing
    self.update_attribute(:status, 1)
  end
  
  def drafting
    self.update_attribute(:status, 0)
  end
  
  def draft?
    self.status == "draft"
  end
  
  # レシピを古い順に並べ替え
  def self.sort_old
    Recipe.order(created_at: :desc)
  end
  
  # レシピをお気に入りの多い順に並べ替え
  def self.sort_likes
    Recipe.includes(:bookmarks).sort {|a,b| b.bookmarks.size <=> a.bookmarks.size}
  end
  
  # レシピキーワード検索
  def self.keyword_search(search)
    keywords = search.split(/[[:blank:]]+/)
    if keywords.empty?
      false
    else
      recipes = Recipe
      keywords.each do |keyword|
        recipes = recipes.where(['title LIKE ? OR explanation LIKE ?', "%#{keyword}%", "%#{keyword}%"])
      end
      recipes
    end
  end
  
  # レシピ特徴検索
  def self.feature_search(search)
    requirement = search.select!{|k, v| v.present?}
    features = Feature.where(requirement)
    id_list = features.pluck(:recipe_id)
    Recipe.where(id: id_list)
  end  
end
