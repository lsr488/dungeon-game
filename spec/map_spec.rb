require_relative "../dungeon"
require_relative "../map"

RSpec.describe Map do
  it "parses an empty dungeon" do
    asciiMap = ""
    player = double("player") # a fake instance of "player" for testing purposes
    dungeon = Dungeon.new(player)

    expect(Map.parse(asciiMap)).to eq(dungeon.rooms)
  end
end