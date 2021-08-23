# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

class MyPiece < Piece
  # The constant All_My_Pieces should be declared here
  All_My_Pieces = [[[[0, 0], [1, 0], [0, 1], [1, 1]]],  # square (only needs one)
               rotations([[0, 0], [-1, 0], [1, 0], [0, -1]]), # T
               [[[0, 0], [-1, 0], [1, 0], [2, 0]], # long (only needs two)
               [[0, 0], [0, -1], [0, 1], [0, 2]]],
               rotations([[0, 0], [0, -1], [0, 1], [1, 1]]), # L
               rotations([[0, 0], [0, -1], [0, 1], [-1, 1]]), # inverted L
               rotations([[0, 0], [-1, 0], [0, -1], [1, -1]]), # S
               rotations([[0, 0], [1, 0], [0, -1], [-1, -1]]), # Z
	       [[[0, 0], [-1, 0], [1, 0], [-2, 0], [2, 0]], #extralong (only needs two)
		[[0, 0], [0, -1], [0, 1], [0, -2], [0, 2]]],
		   rotations([[0, 0], [-1, 0], [1, 0], [1, 1], [0, 1]]), #
                   rotations([[0, 0], [0, -1], [1, 0]])] #three pieces
# your enhancements here
  def self.next_piece (board)
	MyPiece.new(All_My_Pieces.sample, board)
  end
end

class MyBoard < Board
  # your enhancements here
  def initialize (game)
    @grid = Array.new(num_rows) {Array.new(num_columns)}
    @current_block = MyPiece.next_piece(self)
    @score = 0
    @game = game
    @delay = 500
    @cheat = false
  end

  def cheat
   if @score > 100
     @score = @score - 100
     @cheat = true
   end
  end 
      

  def rotate_180
    if !game_over? and @game.is_running?
	@current_block.move(0, 0, 2)
    end 
    draw
  end 
end

class MyTetris < Tetris
  # your enhancements here
  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end

  def self.next_piece (board)
    if @cheat
	single_square = [[0, 0]]
	@current_block = MyPiece.new(single_square, self)
	@cheat = false
    else 
	NyPiece.new(All_My_Pieces.sample, board)
    end
  end 

  def key_bindings
	super
	@root.bind('c', proc {@board.cheat})
	@root.bind('u', proc {@board.rotate_180}) 
  end
	

end

