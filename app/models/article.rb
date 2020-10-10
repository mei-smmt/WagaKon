class Article < ApplicationRecord
  mount_uploader :image, ImageUploader

  belongs_to :user
  has_many :materials, dependent: :destroy
  has_many :steps, dependent: :destroy
  
  # タイトル、画像、説明文必須
  validates :title, presence: true, length: { maximum: 20 }
  validates :image, presence: true
  validates :explanation, presence: true, length: { maximum: 400 }
end
