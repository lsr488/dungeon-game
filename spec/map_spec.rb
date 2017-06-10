require_relative "../dungeon"
require_relative "../map"

RSpec.describe Map do
  before(:example) do
    player = double("player") # a fake instance of "player" for testing purposes
    @dungeon = Dungeon.new(player)
  end

  it "parses an empty dungeon" do
    asciiMap = ""
    expect(Map.parse(asciiMap)).to eq(@dungeon.rooms)
  end
  
  it "parses a map with a room" do
    asciiMap = "A"

    @dungeon.add_room(:smallcave, "Small Cave", "a small claustrophobic cave", {})

    expect(Map.parse(asciiMap)).to eq(@dungeon.rooms)
  end

end