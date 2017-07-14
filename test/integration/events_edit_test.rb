require 'test_helper'

class EventsEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:eric)
  end

  test "unsuccessful edit with invalid data" do
    log_in_as(@user)
    get new_event_path
    assert_difference 'Event.count', 1 do
      post events_path, params: { event: {title: "testing", 
                                          description: "testing", 
                                          date: 10.days.from_now, 
                                          category_id: 450215487, 
                                          address: "Los Angeles, CA" } }
    end
    new_event = Event.find(1001261736)
    get edit_event_path(new_event)
    assert_template 'events/edit'
    patch event_path(new_event), params: { event: {title: "", 
                                          description: "testing", 
                                          date: 10.days.from_now, 
                                          category_id: 450215487, 
                                          address: "Los Angeles, CA" } }
    assert_template 'events/edit'
  end

  test "successful edit with valid data" do
    log_in_as(@user)
    get new_event_path
    assert_difference 'Event.count', 1 do
      post events_path, params: { event: {title: "testing", 
                                          description: "testing", 
                                          date: 10.days.from_now, 
                                          category_id: 450215487, 
                                          address: "Los Angeles, CA" } }
    end
    new_event = Event.find(1001261736)
    get edit_event_path(new_event)
    assert_template 'events/edit'
    patch event_path(new_event), params: { event: {title: "new title", 
                                          description: "testing", 
                                          date: 10.days.from_now, 
                                          category_id: 450215487, 
                                          address: "Los Angeles, CA" } }
    assert_redirected_to new_event
  end

end
