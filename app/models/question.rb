class Question < ActiveRecord::Base
  extend FriendlyId
  friendly_id :text, use: :slugged

  has_many :answers, dependent: :delete_all
  # needed for activeadmin (formtastic)
  accepts_nested_attributes_for :answers

  scope :featured, -> { where(is_featured: true) }

  def votes_count
    self.answers.inject(0) { |sum, answer| sum + answer.votes }
  end
end
