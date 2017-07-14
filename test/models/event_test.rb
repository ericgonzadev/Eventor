require 'test_helper'

class EventTest < ActiveSupport::TestCase

  def setup
    @event = events(:event)
  end

  test "should be valid" do 
    assert @event.valid?
  end

  test "title should be present" do
    @event.title = ""
    assert_not @event.valid?
  end

  test "title should have maximum length" do
    @event.title = "a" * 101
    assert_not @event.valid?
  end

  test "description should be present" do
    @event.description = "      "
    assert_not @event.valid?
  end

  test "description should have maximum length" do
    @event.description = "a" * 1001
    assert_not @event.valid?
  end

  test "address should be present" do
    @event.address = "      "
    assert_not @event.valid?
  end

  test "category_id should be present" do
    @event.category_id = nil
    assert_not @event.valid?
  end

  test "order should be most recent first" do
    assert_equal events(:first_upcoming_event), Event.first
  end

end
