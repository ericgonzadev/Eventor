class Event < ActiveRecord::Base
	default_scope -> { order(date: :asc) }
	mount_uploader :picture, PictureUploader
	belongs_to :user
	has_many :passive_attends, class_name: "Attend", foreign_key: "attended_event_id", dependent: :destroy
	has_many :attendees, through: :passive_attends, source: :attendee
	has_many :comments
	before_validation :normalize_title
	validates :title, presence: true, length: {maximum: 40}
	validates :description, presence: true, length: {maximum: 80}
	validates :address, presence: true
	validate  :picture_size
	geocoded_by :address
	after_validation :geocode

	def Event.upcoming
		Event.all.where("date > ?", Time.now)
	end

	def Event.past
		Event.all.where("date < ?", Time.now)
	end

	def is_valid_date
		self.date < Time.now.advance(days: 1) ? false : true
	end

private

  # Validates the size of an uploaded picture.
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end

  def normalize_title
		self.title = title.downcase.titleize
	end
end
