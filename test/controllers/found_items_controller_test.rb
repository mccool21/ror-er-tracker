require "test_helper"

class FoundItemsControllerTest < ActionDispatch::IntegrationTest
  test "create marks an unfound item as found" do
    sign_in_as(users(:one))

    assert_difference "FoundItem.count", 1 do
      post playthrough_found_items_path(playthroughs(:first_run)),
        params: { item_type: "weapons", item_id: weapons(:zweihander).id }
    end
  end

  test "create is idempotent for an already-found item" do
    sign_in_as(users(:one))

    assert_no_difference "FoundItem.count" do
      post playthrough_found_items_path(playthroughs(:first_run)),
        params: { item_type: "weapons", item_id: weapons(:rapier).id }
    end
  end

  test "create 404s for another user's playthrough" do
    sign_in_as(users(:one))

    post playthrough_found_items_path(playthroughs(:other_users_run)),
      params: { item_type: "weapons", item_id: weapons(:rapier).id }

    assert_response :not_found
  end

  test "destroy unmarks a found item" do
    sign_in_as(users(:one))

    assert_difference "FoundItem.count", -1 do
      delete playthrough_found_item_path(playthroughs(:first_run), found_items(:first_run_found_rapier))
    end
  end
end
