class GamesController < ApplicationController
  
  def index
    #json API respond_with Games.all
    @games = Game.all
  end
  
  def show
    @game = Game.find(params[:id])
    @boards = @game.game_boards.where(:active=>:true)
    @board_archives = @game.game_boards.where(:active=>:false)
    
    #hack for now until more efficient way
    @ids = @game.game_boards.expired.map(&:id)
    @top_posts = Post.where('game_board_id in (?)',@ids).limit(7).order("score desc")
    @recent_posts = Post.where('game_board_id in (?)',@ids).limit(7)
    
    #game stats
    game_boards = GameBoard.where(:game_id => @game.id)
    @num_played = game_boards.size
    @popularity = game_boards.size
    
    @comments = @game.comment_threads.order('created_at desc')
    
    @new_comment = Comment.build_from(@game, current_user.id, "") if user_signed_in?
  end
  
  
end
