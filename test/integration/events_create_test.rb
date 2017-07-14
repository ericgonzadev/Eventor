require 'test_helper'

class EventsCreateTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:eric)
  end

  test "unsuccessful create with guest user" do
    get new_event_path
    assert_redirected_to login_path
  end

  test "invalid event title" do
    log_in_as(@user)
    get new_event_path
    assert_no_difference 'User.count' do
      post events_path, params: { event: {title: "", 
                                          description: "testing event", 
                                          date: 10.days.from_now, 
                                          category_id: 450215487, 
                                          address: "Los Angeles, CA" } }
    end
    assert_template 'events/new'
  end

  test "invalid event decsription" do
    log_in_as(@user)
    get new_event_path
    assert_no_difference 'User.count' do
      post events_path, params: { event: {title: "testing", 
                                          description: "     ", 
                                          date: 10.days.from_now, 
                                          category_id: 450215487, 
                                          address: "Los Angeles, CA" } }
    end
    assert_template 'events/new'
  end

  test "invalid event date" do
    log_in_as(@user)
    get new_event_path
    assert_no_difference 'User.count' do
      post events_path, params: { event: {title: "testing", 
                                          description: "testing", 
                                          date: 10.days.ago, 
                                          category_id: 450215487, 
                                          address: "Los Angeles, CA" } }
    end
    assert_template 'events/new'
  end

  test "successful create with valid user" do
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
    assert_redirected_to new_event
  end

  
end
