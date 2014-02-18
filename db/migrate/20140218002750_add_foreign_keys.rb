class AddForeignKeys < ActiveRecord::Migration
  def change
    change_table :questions do |t|
      t.foreign_key :answers, column: 'correct_answer_id'
    end

    change_table :answers do |t|
      t.foreign_key :questions, dependent: :delete
    end
  end
end
