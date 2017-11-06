require_relative "../dungeon"
require_relative "../map"

RSpec.describe Dungeon do

  before(:example) do
    @player = double("player") # a fake instance of "player" for testing purposes
  end

  it "starts with no rooms" do
    dungeon = Dungeon.new(@player)
    expect(dungeon.rooms).to be_empty
  end

  it "populates rooms from an ASCII map" do
    expected_rooms = {
      small_cave_a: Room.new(:small_cave_a, "Small  Cave", "a small claustrophobic cave", {:east => :other_cave_b}),
      other_cave_b: Room.new(:other_cave_b, "Other Cave", "different cave", {:east => :small_cave_c, :west => :small_cave_a}),
      small_cave_c: Room.new(:small_cave_c, "Small Cave", "not the same cave", {:west => :other_cave_b})
    }

    dungeon = Dungeon.new(@player, "spec/fixtures/map.txt")
    expect(dungeon.rooms).to eq(expected_rooms)
  end

end
