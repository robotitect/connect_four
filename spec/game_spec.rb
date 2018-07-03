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

  context "won?" do
    context "get_containing" do
      it "provides the containing row, col, and diags for an empty board" do
        expect(game.get_containing(1, 2).all? do |row|
          row.all? { |x| x.nil? }
        end).to eql(true)
      end
    end

    example "top left -> bottom right" do
      game.board[0][0] = "X"
      game.board[1][1] = "X"
      game.board[2][2] = "X"
      game.board[3][3] = "X"
      game.print_board
      puts game.get_containing(3, 3).inspect
      expect(game.won?(3, 3)).to eql(true)
    end

    example "top right -> bottom left" do
      game.board[0][6] = "X"
      game.board[1][5] = "X"
      game.board[2][4] = "X"
      game.board[3][3] = "X"
      # game.print_board
      # puts game.get_containing(3, 3).inspect
      expect(game.won?(3, 3)).to eql(true)
    end

    example "horizontal" do
      game.board[1][1..4] = ["X", "X", "X", "X"]
      # game.print_board
      # puts game.get_containing(1, 3).inspect
      expect(game.won?(1, 3)).to eql(true)
    end

    example "vertical" do
      game.board[1][1] = "X"
      game.board[2][1] = "X"
      game.board[3][1] = "X"
      game.board[4][1] = "X"
      # game.print_board
      # puts game.get_containing(1, 1).inspect
      expect(game.won?(1, 1)).to eql(true)
    end

    example_group "failures" do
      example "horizontal" do
        game.board[1][1..4] = ["X", "X", "X", "O"]
        # game.print_board
        # puts game.get_containing(1, 1).inspect
        expect(game.won?(1, 1)).to eql(false)
      end
    end
  end
end
