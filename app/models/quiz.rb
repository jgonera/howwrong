class Quiz < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_many :quiz_questions
  has_many :questions, -> { order "quiz_questions.created_at ASC" }, through: :quiz_questions
end
