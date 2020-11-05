class Step < ApplicationRecord

  belongs_to :recipe
  
  # 手順番号、手順説明文必須
  validates :number, presence: true
  validates :content, presence: true, length: { maximum: 400 }
  
  # 手順の一括保存処理
  def self.bulk_save(steps)
    all_valid = true
    Step.transaction do
      steps.each do |step|
        all_valid &= step.save
      end

      unless all_valid
        raise ActiveRecord::Rollback
      end
    end
    all_valid
  end
end
