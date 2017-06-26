class Comment < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  validates :user_id, presence: true
  validates :body, presence: true
  validates :event_id, presence: true, length: {maximum: 40}
end
