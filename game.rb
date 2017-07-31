require_relative 'player'
require_relative 'dungeon'

#The Game is Watching You
class Game
#saving
#quitting
#parsing user input
#usernames == player name??
#passwords

  attr_accessor :dungeon, :state

  def initialize
    @state = :running
    player = Player.new("Fred Bloggs") # eventually we may need to rearrange how the player, dungeon, and game interact
    @dungeon = Dungeon.new(player)
    add_rooms()
  end

  def run
    #Moving around
    running = true
    while (running) do
      direction = @dungeon.ask_direction()
      if direction == :quit
        running = false
      else
        @dungeon.go(direction)
      end
    end
  end

  private

  def add_rooms
    #Add rooms to Dungeon
    @dungeon.add_room(:smallcave, "Small Cave", "a small claustrophobic cave", {:east => :largecave}) # A 
    @dungeon.add_room(:largecave, "Large Cave", "a large cavernous cave", {:west => :smallcave, :east => :tunnel}) # B
    @dungeon.add_room(:tunnel, "A tunnel", "a rocky tunnel", {:west => :largecave, :east => :smallcave2, :south => :tunnel2}) #C
    @dungeon.add_room(:smallcave2, "Another small cave", "a small and dank cave", {:west => :tunnel}) # D
    @dungeon.add_room(:tunnel2, "A tunnel, too", "a rocky tunnel", {:north => :tunnel, :south => :tunnel3}) # E

    #Start Dungeon by placing player in Small Cave
    @dungeon.start(:smallcave)
  end

end