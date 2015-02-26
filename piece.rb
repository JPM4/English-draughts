class Piece
  RED_VALID_SLIDES = [[-1, -1], [-1, 1]]
  WHITE_VALID_SLIDES = [[1, -1], [1, 1]]
  RED_VALID_JUMPS = [[-1, -2], [-1, 2]]
  WHITE_VALID_JUMPS = [[1, -2], [1, 2]]

  def initialize(color, pos, board, queen = false)
    @color = color
    @pos = position
    @board = board
    @queen = queen
  end

  def symbol
    @queen ? "Q".colorize(@color.to_sym) : "W".colorize(@color.to_sym)
  end

  def possible_moves
    color_moves


  end

  def perform_slide(to_pos)
    possible_moves(@pos)


  end

  def perform_jump

  end

  private

  def off_board?(pos)
    pos.all? { |coord| coord.between?(0, 7) }
  end

  def piece_there?(pos)
    @board[pos] != nil
  end

  def color_moves(color)
    if color == "red"
      RED_VALID_SLIDES + RED_VALID_JUMPS
    else
      WHITE_VALID_SLIDES + WHITE_VALID_JUMPS
    end
  end
end
