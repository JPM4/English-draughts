require_relative 'board.rb'
require_relative 'player.rb'

class Game
  def initialize
    @board = Board.new
    @red = HumanPlayer.new("red", @board)
    @white = HumanPlayer.new("white", @board)
    @player_turn = @red
  end

  def play
    until @board.over?
    begin
      move_seq = @player_turn.get_input
      @board.perform_moves(move_seq)
    rescue => e
      puts "Sorry, error: #{e}"
      retry
    end
      toggle_turn
    end
    toggle_turn
    puts "Congrats #{@player_turn.to_s.capitalize}, you win!"
  end

  def toggle_turn
    @player_turn = (@player_turn == @red ? @white : @red)
  end
end

game = Game.new
game.play
