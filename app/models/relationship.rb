class Relationship < ApplicationRecord
  validates :status, presence: true
  validates :user_id, uniqueness: { scope: :friend_id }
  
  # statusカラム設定
  enum status: { requesting: 0, receiving: 1, approved: 2 }
  
  belongs_to :user
  belongs_to :friend, class_name: 'User'
end
