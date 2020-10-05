class Material < ApplicationRecord
  belongs_to :article
  
  # 材料名、量必須
  validates :name, presence: true
  validates :quantity, presence: true
end
