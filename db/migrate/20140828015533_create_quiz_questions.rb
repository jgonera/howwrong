class CreateQuizQuestions < ActiveRecord::Migration
  def change
    create_table :quiz_questions do |t|
      t.integer :quiz_id
      t.integer :question_id

      t.timestamps
    end

    add_index :quiz_questions, :quiz_id
    add_index :quiz_questions, :question_id
  end
end
