require 'test_helper'

class PagesControllerTest < ActionController::TestCase

  test "should get home" do
    get :index
    assert_response :success
    assert_select "title", "Eventor | Home"
  end

  test "should get about" do
    get :about
    assert_response :success
    assert_select "title", "Eventor | About"
  end

end
