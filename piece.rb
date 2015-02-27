class Piece
  RED_VALID_SLIDES = [[-1, -1], [-1, 1]]
  WHITE_VALID_SLIDES = [[1, -1], [1, 1]]
  RED_VALID_JUMPS = [[-2, -2], [-2, 2]]
  WHITE_VALID_JUMPS = [[2, -2], [2, 2]]

  attr_reader :color, :pos, :queen

  def initialize(color, pos, board, queen = false)
    @color = color
    @pos = pos
    @board = board
    @queen = queen
  end

  def symbol
    @queen ? "Q".colorize(@color.to_sym) : "W".colorize(@color.to_sym)
  end

  def perform_moves!(move_sequence)
    moved = false
    if move_sequence.length == 1
      moved = true if perform_slide(move_sequence.first)
      moved = true if perform_jump(move_sequence.first)
      raise "Not a valid move!" if moved == false
    else
      move_sequence.each do |move|
        raise "No sliding in a multi-move sequence!" if perform_slide(move)
        raise "Invalid jump in that sequence!" unless perform_jump(move)
      end
    end

    true
  end

  def slides
    if @queen
      directions = color_slides("red") + color_slides("white")
    else
      directions = color_slides(@color)
    end

    possible_moves(directions)
  end

  def perform_slide(to_pos)
    return false if !slides.include?(to_pos) || piece_there?(to_pos)
    @board.move(@pos, to_pos)
    @pos = to_pos # do this in the Board#move method
    queen_me if maybe_promote
    true
  end

  def perform_jump(to_pos)
    return false unless possible_jumps.include?(to_pos)
    between_square = between(@pos, to_pos)
    unless piece_there?(between_square) && piece_color(between_square) != @color
      return false
    end
    @board.move(@pos, to_pos)
    @board.remove_piece(between_square)
    @pos = to_pos
    queen_me if maybe_promote
    true
  end

  def possible_jumps
    if @queen
      directions = color_jumps("red") + color_jumps("white")
    else
      directions = color_jumps(@color)
    end

    possible_moves(directions).select { |move| !piece_there?(move) }
  end

  def possible_moves(directions)
    moves = []
    x, y = @pos
    directions.each do |dir|
      moves << [x + dir[0], y + dir[1]]
    end

    moves.select { |move| on_board?(move) }
  end

  private

  def between(start_pos, end_pos)
    a, b = start_pos
    c, d = end_pos
    [(a + c) / 2.0, (b + d) / 2.0]
  end

  def on_board?(pos)
    pos.all? { |coord| coord.between?(0, 7) }
  end

  def piece_there?(pos)
    @board[pos] != nil
  end

  def piece_color(pos)
    @board[pos].color
  end

  def maybe_promote
    return false if @queen
    row, col = @pos
    if @color == "red"
      return row == 0
    else
      return row == 7
    end
  end

  def queen_me
    @queen = true
  end

  def color_slides(color)
    if color == "red"
      RED_VALID_SLIDES
    else
      WHITE_VALID_SLIDES
    end
  end

  def color_jumps(color)
    if color == "red"
      RED_VALID_JUMPS
    else
      WHITE_VALID_JUMPS
    end
  end
end
