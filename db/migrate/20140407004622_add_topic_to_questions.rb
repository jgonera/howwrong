class AddTopicToQuestions < ActiveRecord::Migration
  def change
    change_table :questions do |t|
      t.string :topic
    end
  end
end
