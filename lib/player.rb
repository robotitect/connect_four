class Player
  attr_reader :name, :piece
  @@available_pieces = ["☺", "☻"]
  @@players = 0
  @@human_players = 0
  @@cpu_players = 0

  attr_reader :players

  # Creates a player manually
  def initialize(name, piece)
    @name = name
    @piece = piece
    @@players += 1
  end

  public

  # Asks a user for their name and piece, returns a player
  def self.create_player_with_prompts
    print "What is your name? "
    name = gets.chomp
    piece = nil
    until(piece)
      print "What piece? (X or O) "
      choice = gets.chomp
      if(@@available_pieces.include?(choice))
        piece = @@available_pieces.delete(choice)
      else
        puts "Not Available"
      end
    end
    @@human_players += 1
    Player.new(name, piece)
  end

  # Creates a default player, assigned the first piece of the remaining ones
  def self.create_player_default
    @@human_players += 1
    Player.new("Human #{@@human_players}", @@available_pieces.first)
  end

  def to_s
    print "Name: #{@name}; Piece: #{@piece}"
    # puts "\n" + @@players.to_s + ", " + @@human_players.to_s + ", " + @@cpu_players.to_s
  end

  # Gets the move from a player
  def move(moves)
    puts "#{name}'s move: "
    player_move = nil
    until(player_move)
      puts "Available moves: #{moves.inspect}"
      print "What move? "
      choice = gets.chomp.to_i
      if(moves.include?(choice))
        player_move = choice
      else
        puts "Invalid move"
      end
    end
    player_move
  end
end
