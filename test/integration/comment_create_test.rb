require 'test_helper'

class CommentCreateTest < ActionDispatch::IntegrationTest
  
  test "successful create with valid user" do
    user = users(:eric)
    log_in_as(user)
    event = events(:event)
    assert_difference 'event.comments.count', 1 do
      post event_comments_path(event), params: { 
                                        comment: {
                                          body: "testing", 
                                          user_id: "#{user.id}" 
                                        } 
                                      }
    end
  end

end
