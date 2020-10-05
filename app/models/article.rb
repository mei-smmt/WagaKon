class Article < ApplicationRecord
  belongs_to :user
  has_many :materials, :steps
  
  # タイトル、画像、説明文必須
  validates :title, presence: true, length: { maximum: 20 }
  validates :image, presence: true
  validates :explanation, presence: true, length: { maximum: 400 }
end
