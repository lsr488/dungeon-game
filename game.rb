require_relative 'player'
require_relative 'dungeon'

#The Game is Watching You
class Game
#saving
#quitting
#parsing user input
#usernames == player name??
#passwords

  def initialize
    @state = :running
  end

  def run
    player = Player.new("Fred Bloggs")
    my_dungeon = Dungeon.new(player)

    #Add rooms to Dungeon
    my_dungeon.add_room(:smallcave, "Small Cave", "a small claustrophobic cave", {:east => :largecave}) # A 
    my_dungeon.add_room(:largecave, "Large Cave", "a large cavernous cave", {:west => :smallcave, :east => :tunnel}) # B
    my_dungeon.add_room(:tunnel, "A tunnel", "a rocky tunnel", {:west => :largecave, :east => :smallcave2, :south => :tunnel2}) #C
    my_dungeon.add_room(:smallcave2, "Another small cave", "a small and dank cave", {:west => :tunnel}) # D
    my_dungeon.add_room(:tunnel2, "A tunnel, too", "a rocky tunnel", {:north => :tunnel, :south => :tunnel3}) # E

    #  0123456789
    #0 A--BB C--D
    #1     \ | /  
    #2       EZ-G
    #3       |
    #4       F

    map = %q{
    0-cave:
    A--BB C--D---L
        \ | /    |
          EZ-G^1 M
          |
          F_I

    1-upstairs:
    0_H-J-K
    }



    #Start Dungeon by placing player in Small Cave
    my_dungeon.start(:smallcave)

    #Moving around
    running = true
    while (running) do
      direction = my_dungeon.ask_direction()
    #  if (direction == "quit")
    #    running = false
    #  else
        my_dungeon.go(direction)
    #  end
    end
  end

end