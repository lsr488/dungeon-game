require_relative 'dungeon'
require_relative 'player'

class Map

  def self.parse(asciiMap)
    player = Player.new("DELETE ME AFTER REFACTORING GAME/DUNGEON/PLAYER")
    dungeon = Dungeon.new(player)
    
    # add rooms to dungeon

    dungeon.rooms
  end

end

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

#  0123456789
#0 A--BB C--D
#1     \ | /  
#2       EZ-G
#3       |
#4       F

# map = %q{
# 0-cave:
# A--BB C--D---L
#     \ | /    |
#       EZ-G^1 M
#       |
#       F_I
# 
# 1-upstairs:
# 0_H-J-K
# }