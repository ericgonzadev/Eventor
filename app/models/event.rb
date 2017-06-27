class Event < ActiveRecord::Base
  default_scope -> { order(date: :asc) }
  mount_uploader :picture, PictureUploader
  belongs_to :user
  has_many :passive_attends, class_name: "Attend", foreign_key: "attended_event_id", dependent: :destroy
  has_many :attendees, through: :passive_attends, source: :attendee
  has_many :comments, dependent: :destroy
  validates :title, presence: true, length: {maximum: 100}
  validates :description, presence: true, length: {maximum: 1000}
  validates :address, presence: true
  validates :category_id, presence: true
  validate  :picture_size
  after_validation :normalize_title
  after_validation :exclude_united_states_text_from_address
  geocoded_by :address
  after_validation :geocode, :if => :address_changed?

  def Event.upcoming()
    Event.all.where("date > ?", Time.now)
  end

  def Event.past
    Event.all.where("date < ?", Time.now)
  end

  def Event.featured(visitor_latitude, visitor_longitude)
    Event.upcoming.near([visitor_latitude, visitor_longitude], 20).limit(6)
  end

  def has_valid_date?
    self.date < Time.now.advance(days: 1) ? false : true
  end

  def Event.search(params)
    params[:category].to_i != 0 ? events = Event.where(category_id: params[:category].to_i ) : events = Event.all
    events = events.where("lower(title) LIKE ? or lower(description) LIKE ?", "%#{params[:search].downcase}%", "%#{params[:search.downcase].downcase}%") if params[:search].present?
    events = events.near(params[:location], 30) if params[:location].present?
    params[:timeline] == "Past Events" ? events.past : events.upcoming
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

  def exclude_united_states_text_from_address
    self.address = address.gsub!(/(united states)/i, " ").strip!.chomp!(",") if address.downcase.include?("united states")
  end
end
