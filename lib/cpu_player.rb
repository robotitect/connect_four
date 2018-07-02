require_relative 'player.rb'

class CPUPlayer < Player
  # Manually creates a new computer controlled player
  def initialize(name = "CPU", piece = available_pieces.pop)
    super
  end

  public

  # Factory method for making a computer controlled player
  def self.create_cpu_player
    @@cpu_players += 1
    CPUPlayer.new("CPU #{@@cpu_players}", @@available_pieces.last)
  end

  def move(moves)
    begin
      move = moves.sample
      puts "#{name}'s move is #{move}"
      return move
    rescue
      throw :game_end
    end
  end
end
