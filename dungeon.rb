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
    show_current_description
  end

  def show_current_description
    puts find_room_in_dungeon(@player.location).full_description
  end

  def find_room_in_dungeon(reference)
      @rooms[reference]
  end

  def find_room_in_direction(direction)
    find_room_in_dungeon(@player.location).connections[direction]
  end

  def go(direction)
    puts "You go #{direction}."
    @player.location = find_room_in_direction(direction)
    show_current_description
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

  def full_description
    "\n#{@name}\nYou are in #{@description}."
  end
end

player = Player.new("Fred Bloggs")
my_dungeon = Dungeon.new(player)

#Add rooms to Dungeon
my_dungeon.add_room(:smallcave, "Small Cave", "a small claustrophobic cave", {:east => :largecave})
my_dungeon.add_room(:largecave, "Large Cave", "a large cavernous cave", {:west => :smallcave, :east => :tunnel})
my_dungeon.add_room(:tunnel, "A tunnel", "a rocky tunnel", {:west => :largecave, :east => :smallcave2})
my_dungeon.add_room(:smallcave2, "Another small cave", "a small and dank cave", {:west => :tunnel})
my_dungeon.add_room(:tunnel2, "A tunnel, too", "a rocky tunnel", {:north => :tunnel, :south => :tunnel3})

#Start Dungeon by placing player in large cave
my_dungeon.start(:smallcave)

#Moving around
my_dungeon.go(:east)
my_dungeon.go(:east)
my_dungeon.go(:south)