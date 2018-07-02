require 'game.rb'

describe Game do
  let(:game) { Game.new(1) }

  context "board" do
    it "creates a 7x6 board" do
      expect(game.board).to eql(Array.new(6) { Array.new(7) })
    end

    it "starts empty" do
      expect(game.board.flatten.all? { |x| x.nil? }).to eql(true)
    end
  end

  context "players" do
    it "creates a human and a cpu player" do
      expect(game.players.any? { |x| x.instance_of?(CPUPlayer) }).to eql(true)
      expect(game.players.length).to eql(2)
    end
  end

  context "moves" do
    it "provides a list of valid moves at the beginning of the game" do
      expect(game.moves).to eql([*(1..7)])
    end
  end

  context "move" do
    it "allows the player to make a move" do
      game.move(game.players.last)
      # game.print_board
      expect(game.board.flatten.all? { |x| x.nil? }).to eql(false)
    end
  end
end
