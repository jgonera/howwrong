class RemoveCorrectAnswerIdFromQuestion < ActiveRecord::Migration
  def change
    remove_column :questions, :correct_answer_id, :integer
  end
end
