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

  it "parses a map with two dashes between single-letter rooms" do
    asciiMap = "A--B"

    @dungeon.add_room(:smallcave1, "Small Cave", "a small claustrophobic cave", {:east => :smallcave2})
    @dungeon.add_room(:smallcave2, "Small Cave", "a small claustrophobic cave", {:west => :smallcave1})

    expect(Map.parse(asciiMap)).to eq(@dungeon.rooms)
  end

  it "parses a map with two dashes between a single-letter room and a double-letter room" do
    asciiMap = "AB--C"

    @dungeon.add_room(:smallcave1, "Small Cave", "a small claustrophobic cave", {:east => :smallcave2})
    @dungeon.add_room(:smallcave2, "Small Cave", "a small claustrophobic cave", {:west => :smallcave1})

    expect(Map.parse(asciiMap)).to eq(@dungeon.rooms)
  end

  it "parses a map with a secret, unconnected room" do
    asciiMap = "A-B Z"

    @dungeon.add_room(:smallcave1, "Small Cave", "a small claustrophobic cave", {:east => :smallcave2})
    @dungeon.add_room(:smallcave2, "Small Cave", "a small claustrophobic cave", {:west => :smallcave1})
    @dungeon.add_room(:smallcave3, "Small Cave", "a small claustrophobic cave", {})

    expect(Map.parse(asciiMap)).to eq(@dungeon.rooms)
  end

 it "parses a map with three rooms" do
    asciiMap = "A-B-C"

    @dungeon.add_room(:smallcave1, "Small Cave", "a small claustrophobic cave", {:east => :smallcave2})
    @dungeon.add_room(:smallcave2, "Small Cave", "a small claustrophobic cave", {:west => :smallcave1, :east => :smallcave3})
    @dungeon.add_room(:smallcave3, "Small Cave", "a small claustrophobic cave", {:west => :smallcave2})
      #the code currently overwrites the WHOLE connection hash, not just the SAME key within the hash
    expect(Map.parse(asciiMap)).to eq(@dungeon.rooms)
  end

# write tests for multi-line map parsing
end