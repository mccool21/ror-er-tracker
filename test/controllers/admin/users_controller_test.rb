require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  test "unauthenticated visitors are redirected to sign in" do
    get admin_users_path
    assert_redirected_to new_session_path
  end

  test "standard users are blocked from the index" do
    sign_in_as(users(:one))

    get admin_users_path

    assert_redirected_to root_path
  end

  test "standard users are blocked from updating roles" do
    sign_in_as(users(:one))

    patch admin_user_path(users(:two)), params: { user: { role: "admin" } }

    assert_redirected_to root_path
    assert_not users(:two).reload.admin?
  end

  test "admins can view the index" do
    sign_in_as(users(:admin_user))

    get admin_users_path

    assert_response :success
  end

  test "admins can change another user's role" do
    sign_in_as(users(:admin_user))

    patch admin_user_path(users(:one)), params: { user: { role: "admin" } }

    assert_redirected_to admin_users_path
    assert users(:one).reload.admin?
  end

  test "admins can delete another user" do
    sign_in_as(users(:admin_user))

    assert_difference "User.count", -1 do
      delete admin_user_path(users(:one))
    end

    assert_redirected_to admin_users_path
  end

  test "admins cannot demote themselves" do
    sign_in_as(users(:admin_user))

    patch admin_user_path(users(:admin_user)), params: { user: { role: "standard" } }

    assert_redirected_to admin_users_path
    assert users(:admin_user).reload.admin?
  end

  test "admins cannot delete themselves" do
    sign_in_as(users(:admin_user))

    assert_no_difference "User.count" do
      delete admin_user_path(users(:admin_user))
    end

    assert_redirected_to admin_users_path
  end
end
