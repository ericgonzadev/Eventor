require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  test "params should be present" do
    comment = Comment.new
    assert_not comment.valid?
  end

   test "user should be present" do
    event = events(:event)
    comment = Comment.new(body: "test", event_id: event.id)
    assert_not comment.valid?
  end

  test "body should be present" do
    user = users(:eric)
    event = events(:event)
    comment = Comment.new(user_id: user.id, event_id: event.id)
    assert_not comment.valid?
  end

  test "should be valid" do
    user = users(:eric)
    event = events(:event)
    comment = Comment.new(user_id: user.id, body: "test", event_id: event.id)
    assert comment.valid?
  end
  
end
