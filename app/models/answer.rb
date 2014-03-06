class Answer < ActiveRecord::Base
  belongs_to :question

  default_scope { order 'id' }

  def as_json(options={})
    { id: id, label: label, votes: votes, is_correct: is_correct }
  end
end
