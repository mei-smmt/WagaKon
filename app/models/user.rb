class User < ApplicationRecord
  mount_uploader :image, ImageUploader
  
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  validates :profile, length: { maximum: 500}
  
  has_secure_password
  
  has_many :articles
  has_many :bookmarks
  has_many :favorite_articles, through: :bookmarks, source: :article
  
  def bookmark(article)
    self.bookmarks.find_or_create_by(article_id: article.id)
  end

  def unbookmark(article)
    bookmark = self.bookmarks.find_by(article_id: article.id)
    bookmark.destroy if bookmark
  end

  def favorite?(article)
    self.favorite_articles.include?(article)
  end
  
end
