require_relative 'room'
require_relative 'map'

#The Dungeon
class Dungeon
  attr_accessor :player, :rooms

  def initialize(player, map_filename = nil)
    @player = player
    @rooms = {}

    load_map(map_filename) if map_filename
  end

  def load_map(map_filename)
    ascii_map = File.read(map_filename)
    @rooms = Map.parse(ascii_map)
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
