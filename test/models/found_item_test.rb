require "test_helper"

class FoundItemTest < ActiveSupport::TestCase
  test "rejects an item_type outside TRACKABLE_TYPES" do
    found_item = FoundItem.new(playthrough: playthroughs(:first_run), item_type: "User", item_id: users(:one).id)
    assert_not found_item.valid?
    assert_includes found_item.errors[:item_type], "is not included in the list"
  end

  test "prevents marking the same item found twice for the same playthrough" do
    duplicate = FoundItem.new(playthrough: playthroughs(:first_run), item_type: "Weapon", item_id: weapons(:rapier).id)
    assert_not duplicate.valid?
  end

  test "allows the same item to be found independently across different playthroughs" do
    found_item = FoundItem.new(playthrough: playthroughs(:second_run), item_type: "Weapon", item_id: weapons(:rapier).id)
    assert found_item.valid?
  end
end
