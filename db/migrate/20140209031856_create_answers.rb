class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.string :label
      t.integer :votes
      t.belongs_to :question

      t.timestamps
    end
  end
end
