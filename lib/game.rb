require_relative 'cpu_player.rb'

class Game
  attr_accessor :board, :players, :rows, :cols, :squares_to_coords

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
        unless(element.instance_of?(Fixnum))
          print " " + element.to_s.center(1, " ") + " "
        else
          print " " + "".to_s.center(1, " ") + " "
        end
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

  # Plays the game, asking each player for their move, displaying the board
  # between each move, and then checking for a win condition based on the
  # player's most recent move
  def play_game
    puts "Welcome to Connect Four (#{@rows} x #{@cols})!"
    catch :game_end do
      while(moves)
        print_board
        @players.each do |player|
          # p moves
          moved_row, moved_col = move(player)
          # Checks if player just won with their last move
          if(won?(moved_row, moved_col))
            print_board
            display_win_message(player)
            throw :game_end
          end
        end
      end
      puts "Amazing, a tie game!"
      throw :game_end
    end

    print "Do you want to play again? [y/n] "
    answer = gets.chomp
    if(answer[0] == "y" || answer[0] == "Y")
      Game.new(1, @rows, @cols).play_game
    else
      puts "Bye!"
    end
  end

  def display_win_message(player)
    puts "#{player.name} just won."
  end

  def won?(square_row, square_col)
    puts get_containing(square_row, square_col).inspect
    to_check = get_containing(square_row, square_col)
    to_check.each do |array|
      array.each_index do |i|
        if(!(array[i].nil?) &&
           array[i] == array[i + 1] &&
           array[i + 1] == array[i + 2] &&
           array[i + 2] == array[i + 3])
          return true
        end
      end
    end
    false
  end

  # Returns array get_containing arrays representing elements in the
  # row, column, and diagonals containing the given square
  def get_containing(square_row, square_col)
    cont_row, cont_col, cont_diag1, cont_diag2 = [], [], [], []
    cont_diag2.push(@board[square_row][square_col])

    @board.each_with_index do |row, i|
      row.each_with_index do |ele, j|
        cont_row.push(ele) if i == square_row
        cont_col.push(ele) if j == square_col
        if(i != square_row && j != square_col)
          # top right -> bottom left
          if((i + j) == (square_row + square_col))
            cont_diag2.push(ele)
          end
        end
      end
    end

    # TODO top left -> bottom right
    cont_diag1 << getTopLeftBotRightDiag(square_row, square_col)
    [cont_row, cont_col, cont_diag1.flatten, cont_diag2]
  end

  def getTopLeftBotRightDiag(square_row, square_col)
    to_return = []
    to_return.push(@board[square_row][square_col])
    # up and left
    r_up, c_left = square_row - 1, square_col - 1
    while(r_up >= 0 && c_left >= 0)
      to_return << @board[r_up][c_left]
      r_up -= 1
      c_left -= 1
    end
    to_return.reverse!
    # down and right
    r_down, c_right = square_row + 1, square_col + 1
    while(r_down < @rows && c_right < @cols)
      to_return << @board[r_down][c_right]
      r_down += 1
      c_right += 1
    end
    to_return
  end

  def moves
    to_return = []
    @board.first.each_with_index do |x, i| # iterate to check if top row cell is empty for given column
      to_return << (i + 1) if x.nil?
    end
    to_return
  end

  # returns the [row, col] that was placed into
  def move(player)
    col_to_place = player.move(moves) - 1
    # puts @board.inspect
    @board.each_with_index do |row, i|
      # puts @board[i].inspect
      if(i == @board.size - 1 ||
         @board[i][col_to_place].nil? && !(@board[i + 1][col_to_place].nil?))
        @board[i][col_to_place] = player.piece
        return i, col_to_place
      end
    end
  end
end
