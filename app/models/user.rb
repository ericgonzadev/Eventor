class User < ActiveRecord::Base
	has_many :events, dependent: :destroy
	has_many :active_attends, class_name: "Attend", foreign_key: "attendee_id", dependent: :destroy
	has_many :attending, through: :active_attends, source: :attended_event
	before_validation :normalize_name, on: :create
	before_save :downcase_email
	validates :name, presence: true, length: {maximum: 50}
	validates :email, presence: true, length: {maximum: 50}, uniqueness: { case_sensitive: false }
  validates :password, length: {minimum: 4}
  has_secure_password

	#Adds user to attend list for event
  def attend(event)
    active_attends.create(attended_event_id: event.id)
  end

  #Removes a user from the attend list for event
  def unattend(event)
    active_attends.find_by(attended_event_id: event.id).destroy
  end

  #Returns true if the current user is attending the event
  def attending?(event)
    attending.include?(event)
  end

  #Returns user's upcoming events
  def upcoming_events
    events.where("date > ?", Time.now)
  end

  #Returns user's past events
  def past_events
    events.where("date < ?", Time.now)
  end

private

	# Downcase email before being saved
  def downcase_email
    self.email = email.downcase
  end

  def normalize_name
    self.name = name.downcase.titleize
  end	
end

