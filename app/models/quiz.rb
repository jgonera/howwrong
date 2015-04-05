class Quiz < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_many :quiz_questions
  has_many :questions, -> { order "quiz_questions.created_at ASC" }, through: :quiz_questions

  # TODO: Create a mixin to share with Question
  def self.random(n = 3, exclude: nil)
    # e.g. if we want to choose 1 out of 3, we have 3 offsets to choose from
    # if we want 2 out of 3, we have 2 offsets
    max = count - n + 1

    if exclude.nil?
      ret = self
    else
      max -= exclude.kind_of?(Array) ? exclude.length : 1
      ret = where.not(id: exclude)
    end

    start = rand(max)
    ret.offset(start).limit(n)
  end

  def register_score!(score)
    self.average_score = (times_taken * average_score + score) / (times_taken + 1)
    self.times_taken += 1
    self.save
  end
end
