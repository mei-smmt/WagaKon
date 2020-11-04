class Material < ApplicationRecord
  belongs_to :recipe
  
  # 材料名、量必須
  validates :name, presence: true
  validates :quantity, presence: true
  
  # 材料の一括保存処理
  def self.bulk_save(materials)
    all_valid = true
    Material.transaction do
      materials.each do |material|
        all_valid &= material.save
      end

      unless all_valid
        raise ActiveRecord::Rollback
      end
    end
    all_valid
  end
end
