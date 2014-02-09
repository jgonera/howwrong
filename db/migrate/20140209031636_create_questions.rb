class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :text
      t.belongs_to :correct_answer, class_name: 'Answer'

      t.timestamps
    end
  end
end
