class Comment < ActiveRecord::Base
  belongs_to :event
  validates :user_name, presence: true
  validates :body, presence: true
  validates :event_id, presence: true, length: {maximum: 40}

end
