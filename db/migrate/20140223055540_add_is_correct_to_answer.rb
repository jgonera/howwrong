class AddIsCorrectToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :is_correct, :bool, default: false
  end
end
