class Question < ActiveRecord::Base
  extend FriendlyId
  friendly_id :text, use: :slugged

  has_many :answers, dependent: :delete_all
  # needed for activeadmin (formtastic)
  accepts_nested_attributes_for :answers, allow_destroy: true

  scope :featured, -> { where(is_featured: true) }

  def self.random(n, options = {})
    max = count - n

    if options.has_key? :exclude
      ret = where('id != ?', options[:exclude].id)
    else
      # one more to choose from if we don't exclude one
      max += 1
      ret = self
    end

    start = rand(max)
    ret.offset(start).limit(n)
  end

  def votes_count
    self.answers.inject(0) { |sum, answer| sum + answer.votes }
  end

  # this in fact returns an older (previous) question from the DB point of view
  def next(options = {})
    ret = self.class.where("id < ?", id)
    ret = ret.where.not(id: options[:exclude]) if options.has_key? :exclude
    ret.order("id ASC").first
  end
end
