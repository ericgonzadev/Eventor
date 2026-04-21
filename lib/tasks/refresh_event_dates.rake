namespace :db do
  desc "Push all past event dates into the future (refreshes stale seeded demo data)"
  task refresh_event_dates: :environment do
    days_min = (ENV['DAYS_MIN'] || 2).to_i
    days_max = (ENV['DAYS_MAX'] || 60).to_i

    if days_min < 1 || days_max < days_min
      abort "Invalid range: DAYS_MIN=#{days_min}, DAYS_MAX=#{days_max}. Must satisfy 1 <= DAYS_MIN <= DAYS_MAX."
    end

    past_events = Event.where("date < ?", Time.current)
    total = past_events.count

    if total.zero?
      puts "No past events found — nothing to update."
      next
    end

    puts "Updating #{total} past event(s) to random future dates (#{days_min}-#{days_max} days out)..."

    past_events.find_each do |event|
      # update_column bypasses validations and callbacks — changing just the
      # date shouldn't trigger geocoding or any other side effects, and this
      # is ~10x faster than `save` over many records.
      event.update_column(:date, rand(days_min..days_max).days.from_now)
    end

    puts "Done. #{total} event(s) now have future dates."
  end

  desc "Reshuffle ALL events' dates to random future dates (including already-future ones)"
  task reshuffle_event_dates: :environment do
    days_min = (ENV['DAYS_MIN'] || 2).to_i
    days_max = (ENV['DAYS_MAX'] || 60).to_i

    if days_min < 1 || days_max < days_min
      abort "Invalid range: DAYS_MIN=#{days_min}, DAYS_MAX=#{days_max}. Must satisfy 1 <= DAYS_MIN <= DAYS_MAX."
    end

    total = Event.count

    if total.zero?
      puts "No events found — nothing to update."
      next
    end

    puts "Reshuffling #{total} event(s) to random future dates (#{days_min}-#{days_max} days out)..."

    Event.find_each do |event|
      event.update_column(:date, rand(days_min..days_max).days.from_now)
    end

    puts "Done. All #{total} event(s) now have fresh future dates."
  end
end
