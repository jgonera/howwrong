class Question < ActiveRecord::Base
  extend FriendlyId
  friendly_id :text, use: :slugged
end
