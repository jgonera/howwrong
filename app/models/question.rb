class Question < ActiveRecord::Base
  extend FriendlyId
  friendly_id :text, use: :slugged

  has_many :answers, dependent: :delete_all
  scope :featured, -> { where(is_featured: true) }

end
