class Question < ActiveRecord::Base
  extend FriendlyId
  friendly_id :text, use: :slugged

  has_many :answers
  has_one :correct_answer
end
