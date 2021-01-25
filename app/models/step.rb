class Step < ApplicationRecord

  belongs_to :recipe
  
  # 手順番号、手順説明文必須
  validates :number, presence: true
  validates :content, presence: true, length: { maximum: 60 }, lt4bytes: true

  # 空フォーム除外
  def self.remove_empty_form(form_steps)
    form_steps.each_with_object([]) do |form_step, array|
      array << form_step if form_step[:content].present?
    end
  end

  # 手順の一括更新処理
  def self.bulk_update(recipe, form_steps)
    # 空フォーム除外
    new_steps = Step.remove_empty_form(form_steps)
    # 仮idを設定
    temp_id = Step.last.present? ? Step.last.id + 1 : 1
    # 登録したいレコード数が既存レコード数より多い場合、新規インスタンスを作成
    diff = new_steps.size - recipe.steps.size
    if diff > 0
      new_steps.last(diff).each do |new_step|
        new_step.merge!(id: temp_id)
        recipe.steps.build(new_step)
        temp_id += 1
      end
    end
    all_valid = true
    # 以下、失敗したらロールバック
    Step.transaction do
      # 登録したいレコード数が既存レコード数より少ない場合、余分な既存レコードを削除
      if diff < 0
        recipe.steps.last(-diff).each { |step| step.destroy }
      end
      # 更新処理
      step_number = 1
      recipe.steps.zip(new_steps) do |prev_step, new_step|
        new_step[:number] = step_number
        all_valid &= prev_step.update(new_step)
        step_number += 1
      end
      unless all_valid
        # render後のフォームを補充  
        missing_forms_size = STEP_MAX - new_steps.size
        missing_forms_size.times do
          recipe.steps.build(id: temp_id)
          temp_id += 1
        end
        raise ActiveRecord::Rollback
      end
    end
    all_valid
  end
end
