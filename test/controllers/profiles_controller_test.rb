require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  test "redirects unauthenticated visitors to sign in" do
    get profile_path
    assert_redirected_to new_session_path
  end

  test "shows the current user's own data" do
    sign_in_as(users(:one))

    get profile_path

    assert_response :success
    assert_match users(:one).email_address, response.body
  end
end
