class User < ApplicationRecord
  mount_uploader :image, ImageUploader
  
  before_save { self.email.downcase! }
  validates :personal_id, presence: true,
                          length: { in: 4..12 },
                          format: { with: /\A[a-z0-9]+\z/ },#半角英数字限定
                          uniqueness: true
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
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'friend_id', dependent: :destroy
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

  def friend_request(friend)
    unless self == friend
      self.relationships.find_or_create_by(friend_id: friend.id)
      relationship = friend.relationships.find_or_create_by(friend_id: self.id)
      relationship.update(status: 'receiving')
    end
  end
  
  def friend_approve(friend)
    own_rel = self.relationships.find_by(friend_id: friend.id)
    own_rel.update(status: 'approved') if own_rel
    friend_rel = friend.relationships.find_by(friend_id: self.id)
    friend_rel.update(status: 'approved') if friend_rel
  end
  
  def friend_delete(friend)
    own_rel = self.relationships.find_by(friend_id: friend.id)
    own_rel.destroy if own_rel
    friend_rel = friend.relationships.find_by(friend_id: self.id)
    friend_rel.destroy if friend_rel
  end
  
  def requesting_friend?(friend)
    self.requesting_friends.include?(friend)
  end
  
  def receiving_friend?(friend)
    self.receiving_friends.include?(friend)
  end
  
  def approved_friend?(friend)
    self.approved_friends.include?(friend)
  end
  
  def accessable_recipes
    recipes = self.approved_friends.each_with_object([]) do |friend, array|
      array  << friend.recipes.published
    end
    recipes << self.recipes
    recipes.flatten!
    id_list = recipes.pluck(:id)
    Recipe.where(id: id_list)
  end

  # ユーザー検索
  def self.search(search)
    user = User.find_by(personal_id: search)
    user.present? ? user : ""
  end
end
