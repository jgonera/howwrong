class AddSlugToQuizzes < ActiveRecord::Migration
  def change
    change_table :quizzes do |t|
      t.string :slug
    end

    add_index :quizzes, :slug, unique: true
  end
end
