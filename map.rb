require 'logger'
require_relative 'dungeon'
require_relative 'player'

class Map

  def self.parse(ascii_map)
    rooms, legend_str = parse_map(ascii_map)
    if legend_str
      rooms = parse_legend(legend_str, rooms)
    end
    rooms
  end

  def self.parse_map(ascii_map)
    logger = Logger.new($stderr)

    player = Player.new("DELETE ME AFTER REFACTORING GAME/DUNGEON/PLAYER")
    dungeon = Dungeon.new(player)

    room_count = 0
    curr_room = nil

    prev_room = nil
    prev_char = nil

    found_a_room = false
    found_an_east_west = false
    found_a_south_north = false
    found_end_of_map = false

    legend_start_index = nil
    room_id = ''

    #logger.debug("ASCII MAP: '#{ascii_map}'")

    ascii_map.split(/([A-Z]+)/).each.with_index do |curr_symbol, i|
      if curr_symbol == "\n\n"
        found_end_of_map = true
        legend_start_index = i
        break
      end

      curr_symbol.strip!
      #logger.debug("i = #{i}, curr_symbol = '#{curr_symbol}'")

      if curr_symbol =~ /[A-Z]+/
        room_id += curr_symbol.downcase

        if !found_a_room
          found_a_room = true

          curr_room = dungeon.add_room(room_id.to_sym, curr_symbol, "", {})
          room_count += 1
          room_id = ''

          if found_an_east_west
            found_an_east_west = false
            curr_connections = { :west => prev_room.reference }
            prev_connections = { :east => curr_room.reference }
            prev_room.connections.merge!(prev_connections)
            curr_room.connections.merge!(curr_connections) #the ! means the values are being merged into the same hash, not beind held in a placeholder third hash
          end

          if found_a_south_north
            found_a_south_north = false
            curr_connections = { :north => prev_room.reference }            
            prev_connections = { :south => curr_room.reference }
            prev_room.connections.merge!(prev_connections)
            curr_room.connections.merge!(curr_connections)
          end

          prev_room = curr_room
        end
      else
        found_a_room = false
      end

      if curr_symbol =~ /-+/
        found_an_east_west = true
      end

      if curr_symbol == '|'
        found_a_south_north = true
      end

      prev_char = curr_symbol
    end

    #logger.debug("LEGEND START INDEX: '#{legend_start_index}'")

    if legend_start_index != nil
      legend_length = ascii_map.length - legend_start_index
      legend_str = ascii_map[ legend_start_index, legend_length ]
      #logger.debug("LEGEND: '#{legend_str}'")
    end
   
    [dungeon.rooms, legend_str]
  end

  def self.parse_legend(legend_str, partial_rooms)
    rooms = partial_rooms
    old_id_to_new_id = {}

    legend_info = legend_str.scan(/^([A-Z]+): ([^.]+)\. (.*)$/)

    legend_info.each do |symbol, name, description|
      formatted_name = name.downcase.gsub(/[^a-z]+/, '_')
      old_id = symbol.downcase.to_sym
      new_id = "#{formatted_name}_#{old_id}".to_sym

      old_id_to_new_id[old_id] = new_id

      updated_room = rooms.delete(old_id)
      updated_room.reference = new_id
      updated_room.description = description
      updated_room.name = name
      rooms[new_id] = updated_room
    end

    rooms.values.each do |room|
      room.connections.each do |connection_hash_key_value_pair|
        key, value = connection_hash_key_value_pair
        direction = key
        old_id = value
        new_id = old_id_to_new_id[old_id]
        room.connections[direction] = new_id
      end
    end

    rooms
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
#
# A:  Small Cave. A small cave blah blah. aoeu.
# BB: Other Cave. Nto the smae.
# C:  Small Cave. aoeu.

# :small_cave_a
# :other_cave_bb
# :small_cave_c

# map = %q{
#
# A: Small Cave
#
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