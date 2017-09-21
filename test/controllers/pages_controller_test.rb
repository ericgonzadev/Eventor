require 'test_helper'

class PagesControllerTest < ActionController::TestCase

  test "should get home" do
    get :index
    assert_response :success
    assert_select "title", "Eventor | Home"
  end

end
