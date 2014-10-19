class Question < ActiveRecord::Base
  extend FriendlyId
  friendly_id :text, use: :slugged

  has_many :answers, dependent: :delete_all
  # needed for activeadmin (formtastic)
  accepts_nested_attributes_for :answers, allow_destroy: true

  scope :featured, -> { where(is_featured: true) }

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

  def votes_count
    self.answers.inject(0) { |sum, answer| sum + answer.votes }
  end
end
