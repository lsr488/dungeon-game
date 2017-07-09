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

    @dungeon.add_room(:smallcave1, "Small Cave", "a small claustrophobic cave", {})

    expect(Map.parse(asciiMap)).to eq(@dungeon.rooms)
  end

 it "parses a map with two rooms" do
    asciiMap = "A-B"

    @dungeon.add_room(:smallcave1, "Small Cave", "a small claustrophobic cave", {:east => :smallcave2})
    @dungeon.add_room(:smallcave2, "Small Cave", "a small claustrophobic cave", {:west => :smallcave1})

    expect(Map.parse(asciiMap)).to eq(@dungeon.rooms)
  end

  # A--B, A--BB, AA-B, AA--BB
end