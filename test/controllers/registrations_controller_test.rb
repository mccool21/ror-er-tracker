require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "new" do
    get new_registration_path
    assert_response :success
  end

  test "create with valid params signs up and starts a session" do
    assert_difference "User.count", 1 do
      post registrations_path, params: {
        user: {
          email_address: "newperson@example.com",
          password: "password123",
          password_confirmation: "password123",
          name: "New Person"
        }
      }
    end

    assert_redirected_to playthroughs_path
    assert cookies[:session_id]
  end

  test "create with mismatched password confirmation re-renders new" do
    assert_no_difference "User.count" do
      post registrations_path, params: {
        user: {
          email_address: "newperson@example.com",
          password: "password123",
          password_confirmation: "nope"
        }
      }
    end

    assert_response :unprocessable_entity
  end
end
