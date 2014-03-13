class AddFeedbackIdToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :feedback_id, :integer
  end
end
