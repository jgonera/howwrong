class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.text :text
      t.boolean :is_positive, default: false

      t.timestamps
    end
  end
end
