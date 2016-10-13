class Event < ActiveRecord::Base
  belongs_to :user
  has_many :passive_attends, class_name: "Attend", foreign_key: "attended_event_id", dependent: :destroy
  has_many :attendees, through: :passive_attends, source: :attendee
  default_scope -> { order(date: :asc) }
  validates :title, presence: true, length: {maximum: 40}
  validates :description, presence: true, length: {maximum: 80}

	def Event.upcoming
		Event.all.where("date > ?", Time.now)
	end

	def Event.past
		Event.all.where("date < ?", Time.now)
	end

	def is_valid_date
		self.date < Time.now.advance(days: 1) ? false : true
	end
end
