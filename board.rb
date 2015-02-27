require 'colorize'
require_relative 'piece.rb'

class Board
  def initialize(place_pieces = true)
    generate_board(place_pieces)
  end

  def display
    puts render
  end

  def [](pos)
    x, y = pos
    @board[x][y]
  end

  def []=(pos, value)
    x, y = pos
    @board[x][y] = value
  end

  def move(start_pos, end_pos)
    self[end_pos] = self[start_pos]
    self[start_pos] = nil
  end

  def remove_piece(pos)
    self[pos] = nil
  end

  def valid_move_seq?(move_sequence)
  begin
    board_dup = dup
    board_dup[move_sequence.first].perform_moves!(move_sequence.drop(1))
  rescue => e
    puts "That move sequence does not work: #{e}"
    false
  else
    true
  end
  end

  def over?
    one_side_empty?
  end

  def perform_moves(move_sequence)
    if valid_move_seq?(move_sequence)
      self[move_sequence.first].perform_moves!(move_sequence.drop(1))
    else
      raise "InvalidMoveError"
    end
  end

  private

  def one_side_empty?
    red = 0
    white = 0
    @board.flatten.compact.each do |tile|
      red += 1 if tile.color == "red"
      white += 1 if tile.color == "white"
    end

    red == 0 || white == 0
  end

  def dup
    board_dup = Board.new(false)
    @board.flatten.compact.each do |tile|
      board_dup[tile.pos] = Piece.new(tile.color, tile.pos, board_dup, tile.queen)
    end

    board_dup
  end

  def render
    str = "   "
    8.times do |num|
      str << num.to_s
      str << "  "
    end
    str << "\n"
    8.times do |num|
      str << num.to_s
      str << "  "
      @board[num].each do |tile|
        str << "-" if tile.nil?
        str << tile.symbol if !tile.nil?
        str << "  "
      end
      str << "\n"
    end

    str
  end

  def generate_board(place_pieces)
    @board = Array.new(8) { Array.new(8) }
    return unless place_pieces
    place_starting_pieces
  end

  def place_starting_pieces
    (0...8).each do |row|
      (0...8).each do |col|
        create_piece(row, col)
      end
    end
  end

  def create_piece(row, col)
    if (row + col).odd? && (row <=2 || row >= 5)
      color = ((row <= 2) ? "white" : "red")
      pos = [row, col]
      self[pos] = Piece.new(color, pos, self)
    end
  end
end
