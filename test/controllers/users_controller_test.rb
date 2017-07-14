require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:eric)
  end
  
  test "should get user show page" do
    get user_path(@user)
    assert_response :success
  end

end
