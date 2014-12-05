class AddAverageScoreAndTimesTakenToQuizzes < ActiveRecord::Migration
  def change
    add_column :quizzes, :average_score, :float, default: 0
    add_column :quizzes, :times_taken, :integer, default: 0
  end
end
