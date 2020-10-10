class Step < ApplicationRecord
  mount_uploader :image, ImageUploader
  
  belongs_to :article
  
  # 手順番号、手順説明文必須
  validates :number, presence: true
  validates :content, presence: true, length: { maximum: 400 }
end
