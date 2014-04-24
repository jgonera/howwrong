class Question < ActiveRecord::Base
  extend FriendlyId
  friendly_id :text, use: :slugged

  has_many :answers, dependent: :delete_all
  # needed for activeadmin (formtastic)
  accepts_nested_attributes_for :answers, allow_destroy: true

  scope :featured, -> { where(is_featured: true) }

  def self.random(n, options = {})
    start = rand(count - n + 1)
    ret = offset(start).limit(n)
    ret = ret.where('id != ?', options[:exclude].id) if options.has_key? :exclude
    ret
  end

  def votes_count
    self.answers.inject(0) { |sum, answer| sum + answer.votes }
  end
end
