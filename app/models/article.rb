class Article < ApplicationRecord
  mount_uploader :image, ImageUploader

  # タイトル、画像、説明文必須
  validates :title, presence: true, length: { maximum: 20 }
  validates :image, presence: true
  validates :explanation, presence: true, length: { maximum: 400 }
  validates :status, presence: true
  
  # statusカラム設定
  enum status: { draft: 0, published: 1 }

  belongs_to :user
  has_many :materials, dependent: :destroy
  has_many :steps, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  
  # 記事の公開、非公開設定
  def publishing
    self.update_attribute(:status, 1)
  end
  
  def drafting
    self.update_attribute(:status, 0)
  end

  # 記事検索
  def self.search(search)   
    keywords = search.split(/[[:blank:]]+/)
    articles = []
    
    keywords.each do |keyword|
      next if keyword == "" 
        articles += Article.where(['title LIKE ? OR explanation LIKE ?', "%#{keyword}%", "%#{keyword}%"])   
      end 
    articles.uniq
  end  
end
