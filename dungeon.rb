require 'byebug'

#The Game is Watching You
#class Game
#saving
#quitting
#parsing user input
#usernames == player name??
#passwords
#end

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
my_dungeon.add_room(:smallcave, "Small Cave", "a small claustrophobic cave", {:east => :largecave})
my_dungeon.add_room(:largecave, "Large Cave", "a large cavernous cave", {:west => :smallcave, :east => :tunnel})
my_dungeon.add_room(:tunnel, "A tunnel", "a rocky tunnel", {:west => :largecave, :east => :smallcave2, :south => :tunnel2})
my_dungeon.add_room(:smallcave2, "Another small cave", "a small and dank cave", {:west => :tunnel})
my_dungeon.add_room(:tunnel2, "A tunnel, too", "a rocky tunnel", {:north => :tunnel, :south => :tunnel3})

#Start Dungeon by placing player in Small Cave
my_dungeon.start(:smallcave)

#Moving around
while (true) do # FOREVER?!?
  direction = my_dungeon.ask_direction()
  my_dungeon.go(direction)
end