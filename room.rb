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

  def ==(other)
    other.class == self.class && other.reference == self.reference
  end

  def hash
    self.reference.hash
  end

end
