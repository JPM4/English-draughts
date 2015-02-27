class HumanPlayer
  attr_reader :color

  def initialize(color, board)
    @color = color
    @board = board
  end

  def get_input
    @board.display
    puts "#{@color.capitalize}, it's your move."
    puts "Which piece would you like to move? ('0-5')"
    piece = gets.chomp
    selection = @board[[piece[0].to_i, piece[2].to_i]]
    check_selected_piece(selection)
    puts "Where would you like to move it?"
    puts "Input multiple moves if desired as a sequence."
    puts "e.g. '5-4 3-6'"
    move_seq = gets.chomp
    [selection.pos] + parse_moves(move_seq)
  rescue => e
    puts "Error: #{e}"
    retry
  end

  def check_selected_piece(selection)
    if selection.nil?
      raise "Not a valid position!"
    elsif selection.color != @color
      raise "Not your piece silly!"
    end
  end

  def parse_moves(move_seq)
    moves = []

    until move_seq.length == 0
      x = move_seq[0].to_i
      y = move_seq[2].to_i
      moves << [x, y]
      move_seq.slice!(0..3)
    end

    moves
  end

end
