require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = users(:eric)
  end

  test "should be valid" do 
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end

  test "password should be present (nonblank)" do
    @user.password =  " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = "a" * 4
    assert_not @user.valid?
  end

  test "password and password_confirmation should match" do
    @user.password = "password"
    @user.password_confirmation = "wordpass"
    assert_not @user.valid?
  end

  test "email addresses should be unique" do
    @user.email = "metroid@nintendo.ord"
    assert_not @user.valid?
  end

  test "associated events should be destroyed" do
    user = User.create!(name: "Example User", 
                        email: "user@example.com", 
                        password: "foobar", 
                        password_confirmation: "foobar")

    user.events.create!(title: "testing", 
                        description: "testing", 
                        date: 10.days.from_now, 
                        category_id: 450215487, 
                        address: "Los Angeles, CA")
    
    assert_difference 'Event.count', -1 do
      user.destroy
    end
  end

end
