class Quiz < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_many :quiz_questions
  has_many :questions, -> { order "quiz_questions.created_at ASC" }, through: :quiz_questions

  def register_score!(score)
    self.average_score = (times_taken * average_score + score) / (times_taken + 1)
    self.times_taken += 1
    self.save
  end
end
