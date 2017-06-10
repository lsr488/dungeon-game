require 'byebug'

#The Game is Watching You
class Game
#saving
#quitting
#parsing user input
#usernames == player name??
#passwords

  def initialize(Game)
    @state = :running
  end
end

#The Dungeon
class Dungeon
  attr_accessor :player

  def initialize(player)
    @player = player
    @rooms = {}
  end

  def add_room(reference, name, description, connections)
    @rooms[reference] = Room.new(reference, name, description, connections)
  end

  def start(location)
    @player.location = location
    show_room
  end

  def show_room
    room = find_room_in_dungeon(@player.location)
    puts room.name
    puts "You are in #{room.description}."
    puts "You see exits going #{room.room_connections}."
  end

  def find_room_in_dungeon(reference)
      @rooms[reference]
  end

  def find_room_ref_in_direction(direction)
    find_room_in_dungeon(@player.location).connections[direction]
  end

  def ask_direction
    print '> '
    gets.chomp.to_sym
  end

  def go(direction)
    room_ref = find_room_ref_in_direction(direction)
    if !room_ref
      puts "You cannot go #{direction}."
      return
    end

    room = find_room_in_dungeon(room_ref)
    if !room
      puts "THE WORLD IS BROKEN OH GOD OH GOD!"
      return
    end

    # Go Do Happy Things #behappy
    puts "You go #{direction}.\n\n"
    @player.location = room_ref
    show_room
  end
end

#The Player
class Player
  attr_accessor :name, :location

  def initialize(name)
    @name = name
  end

end

#The Rooms
class Room
  attr_accessor :reference, :name, :description, :connections

  def initialize(reference, name, description, connections)
    @reference = reference
    @name = name
    @description = description
    @connections = connections
  end

  def room_connections
    #connections.keys.map { |x| x.to_s }.join(", ") <-- this is the long way, the below is the shortcut way
    connections.keys.map(&:to_s).join(", ")
  end

end

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

#(byebug) map.each_line { |line| line.each_char { |char| puts "char: '#{char}'" } }

# the map parser iterates over each line of the ASCII map, and looks at each character on each line
# it looks at each character and asks "Is this a letter or not?" (Room codes will never be a number.) 
# If it's a letter, it looks to see if the immediate next character is also a letter (this is to 
# establish if the room-code is a single letter or double letter). The map parser then moves on to the 
# next character. If it's a space, the parser knows there's no connection between the room it just 
# found and whatever room comes next. If the character is something other than a letter or a space, 
# it knows it's a connection space to the next room it finds. The parser will know that `--` or `-` 
# are east-west connections, that `\`= NW-SE, `|` = N/S, and `/` = NE/SW. If it finds a `_` or `^`, 
# those are connections down and up, respectively. (If there is only one room in the up or down 
# direction, it stays on the main map. If there is more than one room in either direction, those rooms 
# will move to a new sub-map indicated by numbers.) When the parser finds `\` `|` `/` characters, it knows 
# it won't find new rooms on that line, but it will remember the connections so when it goes to the 
# next line, it knows how to connect the rooms on Line 0 and Line 2.

# room_id = '' (for LSR: this means the room IDs start as an empty string)
#
# for each line y of map
#   for each character x of line
#
#     is char a letter?
#       append char to room_id
#     else not a letter
#       save current room_id to prev_room(?) (for E/W connections)
#       reset current room_id to ''
#       continue
#     end
#
#     case char
#       when ' '
#         ...do nothing(?)
#       when '-'
#         add E connection to prev_room # TODO: how to add W connection?
#       when '^'
#         add up connection to room # TODO: how? look at a hash?
#       when '_'
#         add down connection to room # TODO: how? look at a hash?
#       when '|'
#         add N/S connection to room # TODO: how? wait for next line, then look at (x, y-2)
#       when '\'
#         add NW/SE connection to room # TODO: how? wait for next line, then look at (x-1, y-2)
#       when '/'
#         add NE/SW connection to room # TODO: how? wait for next line, then look at (x+1, y-2)
#       when /\d/
#         refer to another map # TODO: how? create a hash?
#     end
#   end
# end

# what about allowing peasant-users to modify the map by drawing ASCII maps, too?

# A = Room.new("Small Cave", "a small claustrophobic cave")

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