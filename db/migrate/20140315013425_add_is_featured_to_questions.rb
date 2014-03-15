class AddIsFeaturedToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :is_featured, :bool, default: false
  end
end
