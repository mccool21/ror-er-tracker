require "test_helper"

class PlaythroughTest < ActiveSupport::TestCase
  test "requires a name" do
    playthrough = Playthrough.new(user: users(:one))
    assert_not playthrough.valid?
    assert_includes playthrough.errors[:name], "can't be blank"
  end

  test "found? reflects whether an item has been marked found" do
    assert playthroughs(:first_run).found?(weapons(:rapier))
    assert_not playthroughs(:first_run).found?(weapons(:zweihander))
  end

  test "progress_for counts found items against the total" do
    progress = playthroughs(:first_run).progress_for(Weapon)
    assert_equal 1, progress[:found]
    assert_equal Weapon.count, progress[:total]
  end

  test "destroying a playthrough destroys its found_items" do
    assert_difference "FoundItem.count", -1 do
      playthroughs(:first_run).destroy
    end
  end
end
