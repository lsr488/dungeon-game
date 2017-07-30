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

    @dungeon.add_room(:a, "A", "", {})

    expect(Map.parse(asciiMap)).to eq(@dungeon.rooms)
  end

 it "parses a map with two rooms" do
    asciiMap = "A-B"

    @dungeon.add_room(:a, "A", "", {:east => :b})
    @dungeon.add_room(:b, "B", "", {:west => :a})

    expect(Map.parse(asciiMap)).to eq(@dungeon.rooms)
  end

  it "parses a map with two dashes between single-letter rooms" do
    asciiMap = "A--B"

    @dungeon.add_room(:a, "A", "", {:east => :b})
    @dungeon.add_room(:b, "B", "", {:west => :a})

    expect(Map.parse(asciiMap)).to eq(@dungeon.rooms)
  end

  it "parses a map with two dashes between a single-letter room and a double-letter room" do
    asciiMap = "AB--C"

    @dungeon.add_room(:ab, "AB", "", {:east => :c})
    @dungeon.add_room(:c, "C", "", {:west => :ab})

    expect(Map.parse(asciiMap)).to eq(@dungeon.rooms)
  end

  it "parses a map with a secret, unconnected room" do
    asciiMap = "A-B C"

    @dungeon.add_room(:a, "A", "", {:east => :b})
    @dungeon.add_room(:b, "B", "", {:west => :a})
    @dungeon.add_room(:c, "C", "", {})

    expect(Map.parse(asciiMap)).to eq(@dungeon.rooms)
  end

 it "parses a map with three rooms" do
    asciiMap = "A-B-C"

    @dungeon.add_room(:a, "A", "", {:east => :b})
    @dungeon.add_room(:b, "B", "", {:west => :a, :east => :c})
    @dungeon.add_room(:c, "C", "", {:west => :b})
    expect(Map.parse(asciiMap)).to eq(@dungeon.rooms)
  end

  it "parses multiple lines, two rooms" do
    asciiMap = <<~HEREDOC
      A
      |
      B
    HEREDOC

    @dungeon.add_room(:a, "A", "", {:south => :b})
    @dungeon.add_room(:b, "B", "", {:north => :a})
    expect(Map.parse(asciiMap)).to eq(@dungeon.rooms)
  end

  it "parses multiple lines, three rooms" do
    asciiMap = <<~HEREDOC
      A
      |
      B
      |
      C
    HEREDOC

    @dungeon.add_room(:a, "A", "", {:south => :b})
    @dungeon.add_room(:b, "B", "", {:north => :a, :south => :c})
    @dungeon.add_room(:c, "C", "", {:north => :b})
    expect(Map.parse(asciiMap)).to eq(@dungeon.rooms)
  end

   it "looks up room names and descriptions (legend)" do
    asciiMap = <<~HEREDOC
      A-B-C
      
      A: Small  Cave. a small claustrophobic cave
      B: Other Cave. different cave
      C: Small Cave. not the same cave
    HEREDOC

    @dungeon.add_room(:small_cave_a, "Small  Cave", "a small claustrophobic cave", {:east => :other_cave_b})
    @dungeon.add_room(:other_cave_b, "Other Cave", "different cave", {:west => :small_cave_a, :east => :small_cave_c})
    @dungeon.add_room(:small_cave_c, "Small Cave", "not the same cave", {:west => :other_cave_b})

    expect(Map.parse(asciiMap)).to eq(@dungeon.rooms)
  end

#write test for asymmetric room exits
#write test for multiple pipes
#write test for multi-letter rooms with legends (i is wrong)
#write test for multi-level maps
#write test for multi-area maps
#maybe write test for non-contiguous map lines?
end
