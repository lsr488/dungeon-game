require_relative "../game"

RSpec.describe Game do
  before(:example) do
    #player = double("player") # a fake instance of "player" for testing purposes
    @game = Game.new
  end

  it "should run" do
    expect(@game.state).to eq(:running)
  end

  it "has rooms" do
    expect(@game.dungeon.rooms).not_to be_empty
  end
end

# write test: talks to the map parser
# write test: don't hardcode map start location