require 'colorize'
require_relative 'piece.rb'

class Board
  def initialize(first = true)
    generate_board(first)

  end


  def render
    puts display
  end

  def [](pos)
    x, y = pos
    @board[x][y]
  end

  def []=(pos, value)
    x, y = pos
    @board[x][y] = value
  end



  private

  def display
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

  def generate_board(first)
    @board = Array.new(8) { Array.new(8) }
    return unless first
    place_starting_pieces
  end

  def place_starting_pieces
    starting_positions.each do |pos|
      row, col = pos
      color = row <= 2 ? "white" : "red"
      puts color
      self[pos] = Piece.new(color, pos, self)
    end
  end

  def starting_positions
    evens = starts([0, 2, 6], [1, 3, 5, 7])
    odds = starts([1, 5, 7], [0, 2, 4, 6])
    evens + odds
  end

  def starts(rows, cols)
    positions = []
    rows.each do |row|
      cols.each do |col|
        positions << [row, col]
      end
    end

    positions
  end


end
