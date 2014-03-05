class Answer < ActiveRecord::Base
  belongs_to :question

  default_scope { order 'id' }

  def as_json(options={})
    { label: label, is_correct: is_correct }
  end
end
