require "test_helper"

class PlaythroughsControllerTest < ActionDispatch::IntegrationTest
  test "redirects unauthenticated visitors to sign in" do
    get playthroughs_path
    assert_redirected_to new_session_path
  end

  test "index only shows the current user's playthroughs" do
    sign_in_as(users(:one))

    get playthroughs_path

    assert_response :success
    assert_match playthroughs(:first_run).name, response.body
    assert_no_match playthroughs(:other_users_run).name, response.body
  end

  test "create with valid params" do
    sign_in_as(users(:one))

    assert_difference "Playthrough.count", 1 do
      post playthroughs_path, params: { playthrough: { name: "New Run" } }
    end

    assert_redirected_to playthrough_path(Playthrough.last)
  end

  test "create with invalid params" do
    sign_in_as(users(:one))

    assert_no_difference "Playthrough.count" do
      post playthroughs_path, params: { playthrough: { name: "" } }
    end

    assert_response :unprocessable_entity
  end

  test "show renders the current user's playthrough" do
    sign_in_as(users(:one))

    get playthrough_path(playthroughs(:first_run))

    assert_response :success
  end

  test "show 404s for another user's playthrough" do
    sign_in_as(users(:one))

    get playthrough_path(playthroughs(:other_users_run))

    assert_response :not_found
  end

  test "destroy removes the playthrough and its found_items" do
    sign_in_as(users(:one))

    assert_difference [ "Playthrough.count", "FoundItem.count" ], -1 do
      delete playthrough_path(playthroughs(:first_run))
    end

    assert_redirected_to playthroughs_path
  end
end
