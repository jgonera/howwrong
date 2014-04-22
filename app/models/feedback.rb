class Feedback < ActiveRecord::Base
  def to_s
    "#{is_positive ? "+" : "-"} " + text
  end
end
