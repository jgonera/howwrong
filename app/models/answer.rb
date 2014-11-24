class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :feedback

  default_scope { order 'id' }
  scope :correct, -> { where(is_correct: true).first }
  scope :wrong, -> { where(is_correct: false) }

  def as_json(options={})
    { id: id, label: label, votes: votes, is_correct: is_correct }
  end
end
