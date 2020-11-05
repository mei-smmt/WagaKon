class Ingredient < ApplicationRecord
  belongs_to :recipe
  
  # 材料名、量必須
  validates :name, presence: true
  validates :quantity, presence: true
  
  # 材料の一括保存処理
  def self.bulk_save(ingredients)
    all_valid = true
    Ingredient.transaction do
      ingredients.each do |ingredient|
        all_valid &= ingredient.save
      end

      unless all_valid
        raise ActiveRecord::Rollback
      end
    end
    all_valid
  end
end
