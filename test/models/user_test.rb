require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    user = User.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    assert_equal("downcased@example.com", user.email_address)
  end

  test "defaults to standard role" do
    user = User.new(email_address: "new@example.com", password: "password123")
    assert user.standard?
  end

  test "requires a password for non-oauth signup" do
    user = User.new(email_address: "new@example.com")
    assert_not user.valid?
    assert_includes user.errors[:password], "can't be blank"
  end

  test "does not require a password for oauth users" do
    user = User.new(email_address: "new@example.com", provider: "google_oauth2", uid: "123")
    assert user.valid?
  end

  test "from_omniauth links an existing user by email" do
    auth = OmniAuth::AuthHash.new(
      provider: "google_oauth2",
      uid: "12345",
      info: { email: users(:one).email_address, name: "Test User", image: "http://example.com/a.png" }
    )

    user = User.from_omniauth(auth)

    assert_equal users(:one).id, user.id
    assert_equal "google_oauth2", user.provider
    assert_equal "12345", user.uid
  end

  test "from_omniauth creates a new user when no match exists" do
    auth = OmniAuth::AuthHash.new(
      provider: "google_oauth2",
      uid: "67890",
      info: { email: "brand-new@example.com", name: "New Person", image: "http://example.com/b.png" }
    )

    assert_difference "User.count", 1 do
      User.from_omniauth(auth)
    end
  end
end
