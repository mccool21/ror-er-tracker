require "application_system_test_case"

class UserAuthenticationTest < ApplicationSystemTestCase
  test "signing up, logging out, and logging back in" do
    visit new_registration_path

    fill_in "Email address", with: "system-test@example.com"
    fill_in "Name (optional)", with: "System Tester"
    fill_in "Password", with: "password123"
    fill_in "Confirm password", with: "password123"
    click_button "Sign up"

    assert_text "system-test@example.com"

    click_on "Log out"
    assert_text "Sign in"

    fill_in "Enter your email address", with: "system-test@example.com"
    fill_in "Enter your password", with: "password123"
    click_button "Sign in"

    assert_text "system-test@example.com"
  end

  test "admin can change a user's role and delete a user" do
    sign_in_via_form(users(:admin_user))
    visit admin_users_path

    within "tr", text: users(:one).email_address do
      select "admin", from: "user[role]"
    end
    assert_text "Updated #{users(:one).email_address}"
    assert users(:one).reload.admin?

    within "tr", text: users(:two).email_address do
      accept_confirm { click_on "Delete" }
    end
    assert_text "Deleted #{users(:two).email_address}"
    assert_nil User.find_by(id: users(:two).id)
  end

  test "standard users cannot reach the admin area" do
    sign_in_via_form(users(:one))
    visit admin_users_path

    assert_no_text "Manage Users"
  end

  private
    def sign_in_via_form(user)
      visit new_session_path
      fill_in "Enter your email address", with: user.email_address
      fill_in "Enter your password", with: "password"
      click_button "Sign in"
    end
end
