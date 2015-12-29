class GameBoardsController < ApplicationController

  def show
    #load the game board
    @board = GameBoard.find(params[:id])
    if @board.status == 'active'
      if user_signed_in?
        #check if user has already posted
        @existing_post = Post.unscoped.where(:game_board_id=>params[:id], :user_id=>current_user.id).first
        #load users workspace
        @workspace = current_user.workspaces.where(:game_board_id=>params[:id]).first
        if @workspace

        else
          @workspace = Workspace.new(:user_id=>current_user.id,:game_board_id=>params[:id])
          @workspace.save!
        end
      end
      render 'active'
    else
      @posts = @board.posts
      @total_pages = (@posts.length / 15) + 1
      posts = @posts.pluck(:id)
      if params.has_key?(:page)  && params[:page].to_i > 0
        offset = (params[:page].to_i-1) * 15
        ids = posts[offset..offset+14]
        @posts = Post.where('id in (?)',ids).order(created_at: :desc)
        render :partial => 'posts/just_the_response_masonry', :collection =>@posts, :as => :post
      else

        offset = 0
        ids = posts[offset..offset+14]
        @posts = Post.where('id in (?)',ids).order(created_at: :desc)
        render 'expired'
      end
    end
  end

  def index
    if params[:game].present?
      @boards = GameBoard.where(:status=> 'active', :game_id => params[:game])
    else
      @boards = GameBoard.where(:status=> 'active')
      puts @boards
    end
    @popular = GameBoard.order("score desc")
  end

  def vote
    @board = GameBoard.find(params[:game_board_id])
    if params[:vote_type] == "like"
      @board.add_evaluation(:liked, 1, current_user)
    elsif params[:vote_type] == "love"
      @board.add_evaluation(:loved, 4, current_user)
    end
    respond_to do |format|
      format.js { render 'voted'}
    end
  end

  def archives
    @page_title = "Game Archives"
    if params[:game].present?
      @boards = GameBoard.where(:status=> 'expired', :game_id => params[:game])
    else
      @boards = GameBoard.where(:status=> 'expired')
    end

    render 'index'
  end
end
