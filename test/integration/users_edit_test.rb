require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest 

  def setup
    @user = users(:eric)
  end

  test "unsuccessful edit with invalid data" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }

    assert_template 'users/edit'
  end

  test "unsuccessful edit with another user" do
    log_in_as(users(:archer))
    get edit_user_path(@user)
    assert_redirected_to root_path
  end

  test "unsuccessful edit with guest user" do
    get edit_user_path(@user)
    follow_redirect!
    assert_template root_path
  end

  test "successful edit with changed password" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name:  "Foo Bar",
                                              email: "foo@bar.com",
                                              password:              "foobars",
                                              password_confirmation: "foobars" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal "Foo Bar",  @user.name
    assert_equal "foo@bar.com", @user.email
  end

  test "successful edit without changed password" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name:  "Foo Bar",
                                              email: "foo@bar.com",
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal "Foo Bar",  @user.name
    assert_equal "foo@bar.com", @user.email
  end

end
