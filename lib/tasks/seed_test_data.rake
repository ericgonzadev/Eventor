require 'open-uri'
require 'tempfile'

namespace :db do
  # Download a sample event image. Returns a Tempfile or nil on failure.
  # Tries LoremFlickr (themed) first, falls back to Picsum (random) if that
  # fails — robust against IPv6 or per-host network issues.
  def fetch_sample_image(keywords, seed)
    themed_slug = keywords.gsub(',', '-')
    urls = [
      "https://loremflickr.com/800/400/#{keywords}?lock=#{seed}",
      "https://picsum.photos/seed/#{themed_slug}-#{seed}/800/400"
    ]

    urls.each do |url|
      tempfile = Tempfile.new(['eventor-img', '.jpg'])
      tempfile.binmode
      begin
        URI.open(url, 'rb', open_timeout: 5, read_timeout: 15) do |remote|
          IO.copy_stream(remote, tempfile)
        end
        tempfile.rewind
        return tempfile if tempfile.size > 1000 # filter out error pages
        tempfile.close!
      rescue StandardError
        tempfile.close!
        # Try next URL
      end
    end

    nil
  end

  desc "Wipe all users+events, create 10 users with 5 events each, plus attendance records"
  task seed_test_data: :environment do
    if Rails.env.production? && ENV['I_KNOW_THIS_WIPES_THE_DATABASE'] != 'YES'
      abort <<~MSG
        Refusing to run in production — this task destroys ALL users and events.
        To proceed, set: I_KNOW_THIS_WIPES_THE_DATABASE=YES
      MSG
    end

    puts "== Seeding test data =="

    # --- Wipe all existing users & events (cascades to attends via dependent: :destroy) ---
    attend_count = Attend.count
    event_count  = Event.count
    user_count   = User.count
    User.destroy_all
    Event.destroy_all # safety net if any orphan events exist
    puts "Cleared #{user_count} users, #{event_count} events, #{attend_count} attends"

    # --- Ensure all 16 categories exist ---
    category_names = [
      "Arts", "Business", "Charity", "Education", "Fashion",
      "Film & Media", "Food & Drink", "Health", "Hobbies", "Holiday",
      "Music", "Science & Tech", "Spirituality", "Sports & Fitness",
      "Travel & Outdoor", "Other"
    ]
    category_names.each { |name| Category.find_or_create_by!(name: name) }
    puts "Categories: #{Category.count} ready"

    # --- Sample data ---
    # 10 real names (diverse, realistic)
    people = [
      { first: "Emma",    last: "Thompson" },
      { first: "James",   last: "Rodriguez" },
      { first: "Olivia",  last: "Chen" },
      { first: "Marcus",  last: "Williams" },
      { first: "Sofia",   last: "Patel" },
      { first: "Liam",    last: "OBrien" },
      { first: "Aisha",   last: "Jackson" },
      { first: "Ethan",   last: "Kim" },
      { first: "Zara",    last: "Ahmed" },
      { first: "Noah",    last: "Anderson" }
    ]

    # Real addresses with real lat/lng — avoids hitting the Google Geocoding API
    locations = [
      { address: "123 Hollywood Blvd, Los Angeles, CA 90028",  lat: 34.1016, lng: -118.3267 },
      { address: "1 Market St, San Francisco, CA 94105",       lat: 37.7946, lng: -122.3951 },
      { address: "350 5th Ave, New York, NY 10118",            lat: 40.7484, lng: -73.9857  },
      { address: "233 S Wacker Dr, Chicago, IL 60606",         lat: 41.8789, lng: -87.6359  },
      { address: "600 Congress Ave, Austin, TX 78701",         lat: 30.2672, lng: -97.7431  },
      { address: "400 Broad St, Seattle, WA 98109",            lat: 47.6205, lng: -122.3493 },
      { address: "800 Boylston St, Boston, MA 02199",          lat: 42.3479, lng: -71.0820  },
      { address: "401 Biscayne Blvd, Miami, FL 33132",         lat: 25.7781, lng: -80.1876  },
      { address: "1701 Wynkoop St, Denver, CO 80202",          lat: 39.7526, lng: -104.9995 },
      { address: "1111 NE Grand Ave, Portland, OR 97232",      lat: 45.5339, lng: -122.6607 }
    ]

    event_templates = [
      { title: "Summer Music Festival",        category: "Music",             image_keywords: "music,festival",    description: "Three days of live music across multiple stages, featuring top artists and local favorites. Food trucks, art installations, and vendor booths throughout the weekend." },
      { title: "Tech Startup Meetup",          category: "Business",          image_keywords: "startup,office",    description: "Connect with founders, investors, and engineers. Lightning talks, networking hour, and a panel discussion on emerging technologies shaping the industry." },
      { title: "Community Charity Run",        category: "Charity",           image_keywords: "charity,running",   description: "5K run/walk benefiting local food banks. All fitness levels welcome. Registration includes a t-shirt, finisher medal, and post-race refreshments." },
      { title: "Modern Art Exhibition",        category: "Arts",              image_keywords: "art,gallery",       description: "Opening night reception for new contemporary works by emerging artists. Wine, hors d'oeuvres, and conversations with the creators." },
      { title: "Weekend Food Truck Rally",     category: "Food & Drink",      image_keywords: "foodtruck,street",  description: "Over 20 food trucks serving cuisines from around the world. Live music, family-friendly games, and local craft vendors." },
      { title: "Indie Film Screening",         category: "Film & Media",      image_keywords: "cinema,film",       description: "Award-winning independent films followed by Q&A sessions with the directors. Concessions and themed cocktails available." },
      { title: "Yoga in the Park",             category: "Health",            image_keywords: "yoga,park",         description: "All-levels outdoor yoga class followed by guided meditation. Bring your own mat. Free for first-time attendees." },
      { title: "Photography Workshop",         category: "Hobbies",           image_keywords: "photography,camera",description: "Hands-on workshop covering composition, lighting, and editing. Bring your camera or smartphone. Instructors are award-winning photographers." },
      { title: "Coding Bootcamp Info Session", category: "Education",         image_keywords: "coding,computer",   description: "Learn about our full-stack web development program. Meet instructors, see student projects, and get your questions answered." },
      { title: "City Marathon",                category: "Sports & Fitness",  image_keywords: "marathon,runners",  description: "Annual marathon and half-marathon winding through scenic neighborhoods. Pacers available, water stations every mile, post-race beer garden." },
      { title: "Fashion Week Runway Show",     category: "Fashion",           image_keywords: "fashion,runway",    description: "Debut runway presentations from five local designers. Cocktail hour, live DJ, and meet-the-designer afterparty." },
      { title: "Holiday Market",               category: "Holiday",           image_keywords: "holiday,market",    description: "Handcrafted gifts from over 50 local artisans. Hot cocoa, live carolers, and visits with Santa for the kids." },
      { title: "Mindfulness Retreat",          category: "Spirituality",      image_keywords: "meditation,zen",    description: "Day-long silent retreat with guided sittings, walking meditation, and a vegetarian lunch. No experience necessary." },
      { title: "National Park Day Hike",       category: "Travel & Outdoor",  image_keywords: "hiking,mountain",   description: "Guided 6-mile moderate hike through old-growth forest. Lunch, trail snacks, and transportation from the meeting point provided." },
      { title: "Science Expo",                 category: "Science & Tech",    image_keywords: "science,laboratory",description: "Interactive exhibits, live demonstrations, and talks from working scientists. Great for all ages; hands-on fun for kids." },
      { title: "Open Mic Night",               category: "Other",             image_keywords: "microphone,stage",  description: "Sign up at the door. Five minutes per performer. Music, comedy, poetry, and anything else you want to share." }
    ]

    # --- Create 10 users with real names ---
    users = people.map do |p|
      email = "#{p[:first].downcase}.#{p[:last].downcase}@eventor.test"
      User.create!(
        name: "#{p[:first]} #{p[:last]}",
        email: email,
        password: "password123",
        password_confirmation: "password123"
      )
    end
    puts "Users: #{users.size} created (password: password123)"

    # --- Create 5 events per user ---
    # Skip geocode callback so we can supply lat/lng directly (no Google API calls).
    Event.skip_callback(:validation, :after, :geocode)

    all_events = []
    fetch_images = !ENV['SKIP_IMAGES'].to_s.match?(/\A(1|true|yes)\z/i)
    images_succeeded = 0
    images_failed = 0

    puts fetch_images ? "Fetching sample images from loremflickr.com (set SKIP_IMAGES=1 to skip)..." : "Image fetching disabled (SKIP_IMAGES set)"

    begin
      users.each_with_index do |user, user_idx|
        # Pick 5 distinct templates so a single user never has duplicate event titles
        event_templates.sample(5).each do |template|
          location = locations.sample
          category = Category.find_by!(name: template[:category])

          event = user.events.build(
            title:       template[:title],
            description: template[:description],
            date:        rand(2..60).days.from_now,
            category_id: category.id,
            address:     location[:address],
            latitude:    location[:lat],
            longitude:   location[:lng]
          )

          # Fetch a themed image. If download fails, the event just has no picture.
          if fetch_images
            seed = "#{user_idx}-#{template[:title]}".hash.abs
            if (image_file = fetch_sample_image(template[:image_keywords], seed))
              event.picture = image_file
              images_succeeded += 1
            else
              images_failed += 1
            end
          end

          event.save!
          image_file&.close!

          # Creator auto-attends (matches EventsController#create)
          user.attend(event)
          all_events << event
          print "." # progress dot per event
        end
      end
      puts ""
    ensure
      Event.set_callback(:validation, :after, :geocode, if: :address_changed?)
    end

    puts "Events: #{all_events.size} created (5 per user)"
    if fetch_images
      puts "Images: #{images_succeeded} attached, #{images_failed} failed"
    end

    # --- Generate attendance records ---
    # For each event, 3-8 additional attendees drawn from other users.
    # Creators are already attending; this adds social density.
    attend_records = 0
    all_events.each do |event|
      other_users = users - [event.user]
      num_extra_attendees = rand(3..8)

      other_users.sample(num_extra_attendees).each do |attendee|
        attendee.attend(event)
        attend_records += 1
      end
    end

    total_attends = Attend.count
    puts "Attends: #{attend_records} additional records created (#{total_attends} total including creators)"

    # --- Summary stats ---
    puts ""
    puts "== Done =="
    puts "  #{User.count} users"
    puts "  #{Event.count} events"
    puts "  #{Attend.count} attend records"
    puts ""
    puts "Event attendance range:"
    events_by_attendance = Event.joins(:passive_attends).group("events.id").count
    if events_by_attendance.any?
      min_attendees = events_by_attendance.values.min
      max_attendees = events_by_attendance.values.max
      avg_attendees = (events_by_attendance.values.sum.to_f / events_by_attendance.size).round(1)
      puts "  min: #{min_attendees}, max: #{max_attendees}, avg: #{avg_attendees} per event"
    end
    puts ""
    puts "User attendance range:"
    users_by_attending = User.joins(:active_attends).group("users.id").count
    if users_by_attending.any?
      min_attending = users_by_attending.values.min
      max_attending = users_by_attending.values.max
      avg_attending = (users_by_attending.values.sum.to_f / users_by_attending.size).round(1)
      puts "  min: #{min_attending}, max: #{max_attending}, avg: #{avg_attending} events per user"
    end
    puts ""
    puts "Login: emma.thompson@eventor.test / password123  (or any of the 10 seeded emails)"
  end

  desc "Remove all users, events, and attends"
  task clear_test_data: :environment do
    if Rails.env.production? && ENV['I_KNOW_THIS_WIPES_THE_DATABASE'] != 'YES'
      abort <<~MSG
        Refusing to run in production — this task destroys ALL users and events.
        To proceed, set: I_KNOW_THIS_WIPES_THE_DATABASE=YES
      MSG
    end

    user_count  = User.count
    event_count = Event.count
    User.destroy_all
    Event.destroy_all
    puts "Removed #{user_count} users and #{event_count} events."
  end
end
