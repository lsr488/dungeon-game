require_relative 'player'
require_relative 'dungeon'
require_relative 'map'

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
    @dungeon = Dungeon.new(player, "spec/fixtures/map_bigger.txt")
    @dungeon.start(:small_cave_a)
  end

  def run
    #Moving around
    running = true
    while (running) do
      direction = @dungeon.ask_direction()
      if direction == :quit
        running = false
      elsif direction == :look
        @dungeon.show_room
      else
        @dungeon.go(direction)
      end
    end
  end

end
