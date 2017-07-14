require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest

  def setup
    Rails.application.load_seed
    @event = events(:event)
  end

  test "should get events index" do
    get '/events'
    assert_response :success
    assert_select "title", "Eventor | All Events"
  end

  test "should get events show page" do
    get event_path(@event)
    assert_response :success
    assert_select "title", "Eventor | #{@event.title}"
  end

end
