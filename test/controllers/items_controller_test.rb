require "test_helper"

class ItemsControllerTest < ActionDispatch::IntegrationTest
  test "redirects unauthenticated visitors to sign in" do
    get items_playthrough_path(playthroughs(:first_run), item_type: "weapons")
    assert_redirected_to new_session_path
  end

  test "index lists items of the given type with found status" do
    sign_in_as(users(:one))

    get items_playthrough_path(playthroughs(:first_run), item_type: "weapons")

    assert_response :success
    assert_match weapons(:rapier).name, response.body
    assert_match weapons(:zweihander).name, response.body
    assert_match "Found", response.body
  end

  test "index 404s for an unknown item type" do
    sign_in_as(users(:one))

    get items_playthrough_path(playthroughs(:first_run), item_type: "not-a-real-type")

    assert_response :not_found
  end

  test "index 404s for another user's playthrough" do
    sign_in_as(users(:one))

    get items_playthrough_path(playthroughs(:other_users_run), item_type: "weapons")

    assert_response :not_found
  end

  test "show renders a single item" do
    sign_in_as(users(:one))

    get item_playthrough_path(playthroughs(:first_run), item_type: "weapons", item_id: weapons(:rapier).id)

    assert_response :success
    assert_match weapons(:rapier).name, response.body
  end
end
