class AddVotesDefaultToAnswers < ActiveRecord::Migration
  def up
    change_column_default :answers, :votes, 0
  end

  def down
    change_column_default :answers, :votes, nil
  end
end
