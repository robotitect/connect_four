require_relative 'cpu_player.rb'

class Game
  attr_accessor :board, :players, :rows, :cols

  def initialize(players = 1, r = 6, c = 7)
    @rows, @cols = r, c
    @board = Array.new(r) { Array.new(c) } # Access (row, column): [row][column]
    @players = [Player.create_player_default]
    if(players == 1)
      @players << CPUPlayer.create_cpu_player
    else
      @players << Player.create_player_default
    end
  end

  # Prints the current state of the playing board; looks like:
  #   1   2   3
  # |   |   |   |
  # +---+---+---+
  # |   |   |   |
  # +---+---+---+
  # |   |   |   |
  # +---+---+---+
  def print_board
    print "\n\n           "
    @board.first.each_with_index do |element, index|
      print (index + 1).to_s.center(4, " ")
    end
    puts

    @board.each_with_index do |row, index|
      print "          |"
      row.each_with_index do |element, index|
        print " " + element.to_s.center(1, " ") + " "
        if(index < row.length - 1)
          print "|"
        else
          print "|\n"
        end
      end

      if(index < @board.length)
        print "          +"
        row.each_with_index do |element, index|
          print "---"
          if(index < row.length - 1)
            print "+"
          else
            print "+\n"
          end
        end
      end
    end
    puts "\n\n"
  end

  def moves
    to_return = []
    @board.first.each_with_index do |x, i| # iterate to check if top row cell is empty for given column
      to_return << (i + 1) if x.nil?
    end
    to_return
  end

  def move(player)
    col_to_place = player.move(moves) - 1
    board.reverse.each do |row| # goes through rows in reverse
      if(row[col_to_place].nil?)
        row[col_to_place] = player.piece
        break
      end
    end
  end
end
