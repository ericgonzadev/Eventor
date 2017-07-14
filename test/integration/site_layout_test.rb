require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:eric)
  end

  test "links on root page as a guest" do
    get "/"
    assert_select "a[href=?]", signup_path, text: "Sign Up"
    assert_select "a[href=?]", login_path, text: "Login"
  end

  test "links on root page as signed in user" do
    log_in_as(@user)
    get "/"
    assert_select "a[href=?]", "/create-event", text: "Create Event"
    assert_select "a[href=?]", user_path(@user), text: "Profile"
  end
end
