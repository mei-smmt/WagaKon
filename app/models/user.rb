class User < ApplicationRecord
  mount_uploader :image, ImageUploader
  
  before_save { self.email.downcase! }
  validates :personal_id, presence: true, length: { in: 4..8 }, format: { with: /\A[a-z0-9]+\z/ }, uniqueness: true
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
  
  has_many :relationships, dependent: :destroy
  has_many :friends, through: :relationships, source: :friend
  has_many :requesting_relationships, -> { requesting }, class_name: 'Relationship'
  has_many :requesting_friends, through: :requesting_relationships, source: :friend
  has_many :receiving_relationships, -> { receiving }, class_name: 'Relationship'
  has_many :receiving_friends, through: :receiving_relationships, source: :friend
  has_many :approved_relationships, -> { approved }, class_name: 'Relationship'
  has_many :approved_friends, through: :approved_relationships, source: :friend
  
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

  def friend_request(user)
    self.relationships.find_or_create_by(friend_id: user.id)
    user.relationships.find_or_create_by(friend_id: self.id, status: 'receiving')
  end
  
  def friend_delete(user)
    relationship = self.relationships.find_by(friend_id: user.id)
    relationship.destroy if relationship
    relationship = user.relationships.find_by(friend_id: self.id)
    relationship.destroy if relationship
  end
  
  def requesting_friend?(user)
    self.requesting_friends.include?(user)
  end
  
  def receiving_friend?(user)
    self.receiving_friends.include?(user)
  end
  
  def approved_friend?(user)
    self.approved_friends.include?(user)
  end
  
  # ユーザー検索
  def self.search(search)
    user = User.find_by(personal_id: search)
    if user.present?
      user
    else
      ""
    end
  end
end
