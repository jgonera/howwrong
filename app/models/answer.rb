class Answer < ActiveRecord::Base
  belongs_to :question

  default_scope { order 'id' }
end
