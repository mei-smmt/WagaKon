class Step < ApplicationRecord

  belongs_to :recipe
  
  # 手順番号、手順説明文必須
  validates :number, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  # 空フォーム除外
  def self.remove_empty_form(form_steps)
    array = []
    form_steps.each do |form_step|
      if form_step[:content].present?
        array << form_step
      end
    end
    array
  end

  # 材料の一括保存処理
  def self.bulk_create(recipe, steps, form_steps)
    # 空フォーム除外
    new_steps = Step.remove_empty_form(form_steps)
    # 新規インスタンスを作成
    new_steps.each do |new_step|
      steps << recipe.steps.build(new_step)
    end
    all_valid = true
    # 以下、失敗したらロールバック
    Step.transaction do
      step_number = 1
      steps.each do |step|
        step[:number] = step_number
        all_valid &= step.save
        step_number += 1
      end
      unless all_valid
      # render後のフォームを補充  
        missing_forms_size = 10 - new_steps.size
        missing_forms_size.times do
          steps << recipe.steps.build
        end
        raise ActiveRecord::Rollback
      end
    end
    all_valid
  end

  # 材料の一括更新処理
  def self.bulk_update(recipe, form_steps)
    # 空フォーム除外
    new_steps = Step.remove_empty_form(form_steps)
    # 仮idを設定
    temp_id = Step.last.id + 1
    # 登録したいレコード数が既存レコード数より多い場合、新規インスタンスを作成
    diff = new_steps.size - recipe.steps.size
    if diff > 0
      new_steps.last(diff).each do |new_step|
        new_step.merge!(id: temp_id)
        temp_id += 1
        recipe.steps.build(new_step)
      end
    end
    all_valid = true
    # 以下、失敗したらロールバック
    Step.transaction do
      # 登録したいレコード数が既存レコード数より少ない場合、余分な既存レコードを削除
      if diff < 0
        recipe.steps.last(-diff).each do |step|
          step.destroy
        end
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
        missing_forms_size = 10 - new_steps.size
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

  
#   # 手順の一括保存処理
#   def self.bulk_save(steps)
#     all_valid = true
#     Step.transaction do
#       steps.each do |step|
#         all_valid &= step.save
#       end

#       unless all_valid
#         raise ActiveRecord::Rollback
#       end
#     end
#     all_valid
#   end
# end
