class PostsController < ApplicationController

  respond_to :html, :json

  def index
    @more_posts_path = posts_path
    if params[:board].present?
      @posts = Post.where(:game_board_id => params[:board])
    elsif params[:user].present?
      @posts = Post.where(:user_id => params[:user])
    elsif params[:game].present?
      @game = Game.find(params[:game])
      @ids = @game.game_boards.expired.map(&:id)
      @posts = Post.where('game_board_id in (?)',@ids).limit(25).order("score desc")

    else
      @posts = Post.all
    end
    @total_pages = (@posts.length / 15) + 1

    posts = @posts.pluck(:id)
    if params.has_key?(:page)  && params[:page].to_i > 0
      offset = (params[:page].to_i-1) * 15
      ids = posts[offset..offset+14]
      @posts = Post.where('id in (?)',ids).order(created_at: :desc)
      render :partial => @posts
    else

      offset = 0
      ids = posts[offset..offset+14]
      @posts = Post.where('id in (?)',ids).order(created_at: :desc)
    end
  end

  def popular

    if(params[:game_id].present?)
      @game = Game.find(params[:game_id])
      @ids = @game.game_boards.expired.map(&:id)
      @posts = Post.where('game_board_id in (?)',@ids).limit(25).paginate(:per_page => 20, :page => params[:page]).order("score desc")
    else
      @posts = Post.all.order("score desc")
    end
    @more_posts_path = popular_posts_path
    posts = @posts.pluck(:id)
    if params.has_key?(:page)  && params[:page].to_i > 0
      offset = (params[:page].to_i-1) * 15
      ids = posts[offset..offset+14]
      @posts = Post.where('id in (?)',ids).order(created_at: :desc)
      render :partial => @posts
    else

      offset = 0
      ids = posts[offset..offset+14]
      @posts = Post.where('id in (?)',ids).order(created_at: :desc)
    end
    render :index
  end

  def subscriptions
    subscribed_users = current_user.subscriptions.where(:subscription_type => "user").collect(&:subscription_id)
    if(params[:game_id].present?)
      @game = Game.find(params[:game_id])
      @ids = @game.game_boards.expired.map(&:id)
      @posts = Post.where('game_board_id in (?) and user_id IN (?)',@ids, subscribed_users).limit(25).paginate(:per_page => 20, :page => params[:page]).find_with_reputation(:rating, :all, {:order => "rating desc"})
    else
      @posts = Post.where("user_id IN (?)", subscribed_users)
    end
    @more_posts_path = subscriptions_posts_path
    posts = @posts.pluck(:id)
    if params.has_key?(:page)  && params[:page].to_i > 0
      offset = (params[:page].to_i-1) * 15
      ids = posts[offset..offset+14]
      @posts = Post.where('id in (?)',ids).order(created_at: :desc)
      render :partial => @posts
    else

      offset = 0
      ids = posts[offset..offset+14]
      @posts = Post.where('id in (?)',ids).order(created_at: :desc)
    end
    render :index
  end

  def flagged
    @posts = Post.unscoped.where(:status => 'flagged')
    render :flagged
  end

  def familiar
    familiar_users = current_user.familiar_users.collect(&:id)
    if(params[:game_id].present?)
      @game = Game.find(params[:game_id])
      @ids = @game.game_boards.expired.map(&:id)
      @posts = Post.where('game_board_id in (?) and user_id IN (?)',@ids, familiar_users).limit(25).paginate(:per_page => 20, :page => params[:page]).find_with_reputation(:rating, :all, {:order => "rating desc"})
    else
      @posts = Post.where("user_id IN (?)", familiar_users)
    end
    @more_posts_path = familiar_posts_path
    posts = @posts.pluck(:id)
    if params.has_key?(:page)  && params[:page].to_i > 0
      offset = (params[:page].to_i-1) * 15
      ids = posts[offset..offset+14]
      @posts = Post.where('id in (?)',ids).order(created_at: :desc)
      render :partial => @posts
    else

      offset = 0
      ids = posts[offset..offset+14]
      @posts = Post.where('id in (?)',ids).order(created_at: :desc)
    end
    render :index
  end

  def user_games
    user_games = current_user.posts.map(&:game_board_id)
    @posts = Post.where("game_board_id IN (?)", user_games)
    @more_posts_path = user_games_posts_path
    posts = @posts.pluck(:id)
    if params.has_key?(:page)  && params[:page].to_i > 0
      offset = (params[:page].to_i-1) * 15
      ids = posts[offset..offset+14]
      @posts = Post.where('id in (?)',ids).order(created_at: :desc)
      render :partial => @posts
    else

      offset = 0
      ids = posts[offset..offset+14]
      @posts = Post.where('id in (?)',ids).order(created_at: :desc)
    end
    render :index
  end

  def create

    if params[:post][:body].length == 0
      flash[:notice] = "Your submission can't be empty"
      redirect_to :back
    else
      @post = Post.create(post_params)
      if @post.valid?
        flash[:notice] = "your post has been saved, though you may still go back and edit until the game ends"
        redirect_to game_boards_path
      else

        flash[:notice] = @post.errors.full_messages
        redirect_to game_boards_path
      end
    end
  end

  def show
    #get some security on this so people can't see unpublished posts
    @post = Post.unscoped.find(params[:id])

    @comments = @post.comment_threads.order('created_at desc')
    @new_comment = Comment.build_from(@post, current_user.id, "") if user_signed_in?
    @board = GameBoard.find(@post.game_board_id)
    @game_name = @board.game.title
  end

  def edit
    @post = Post.unscoped.find(params[:id])
    render :action => "index"
  end

  def update
    @post = Post.unscoped.find(params[:id])
    @post.body = params[:post][:body]
    if @post.save
      @notice="your post has been saved"
      respond_to do |format|
        format.js {render 'update'}
      end
    else
      @notice=@post.errors.full_messages[0]
      respond_to do |format|
        format.js {render 'update'}
      end
    end
  end

  def destroy
    @post = Post.unscoped.find(params[:id])
    @post.destroy
    flash[:notice] = "Successfully destroyed post."
    redirect_to profile_path(current_user.name)
  end

  def create_or_destroy_reaction
    @post = Post.find(params[:post_id])
    cancelled = false;
    @reaction = Reaction.where(:post_id => params[:post_id], :user_id => current_user.id, :reaction_type => params[:type]).first
    if @reaction.present?
      Reaction.destroy(@reaction.id)
      cancelled = true
    else
      @reaction = Reaction.create(:post_id => params[:post_id], :user_id => current_user.id, :reaction_type => params[:type])
    end
    case params[:type]
      when 'like'
        if cancelled
          @post.update_attribute(:score, @post.score+1)
          @post.user.update_attribute(:score, @post.user.score+1)
        else
          @post.update_attribute(:score, @post.score+1)
          @post.user.update_attribute(:score, @post.user.score+1)
        end

        @count = @post.reactions.liked.size
        @class = "like"
        render 'reactions/liked'
      when 'love'
        if cancelled
          @post.update_attribute(:score, @post.score-3)
          @post.user.update_attribute(:score, @post.user.score-3)
        else
          @post.update_attribute(:score, @post.score+3)
          @post.user.update_attribute(:score, @post.user.score+3)
        end


        @count = @post.reactions.loved.size
        @class = "love"
        render 'reactions/liked'
      when 'share'
        if cancelled
          @post.update_attribute(:score, @post.score-5)
          @post.user.update_attribute(:score, @post.user.score-5)
        else
          @post.update_attribute(:score, @post.score+5)
          @post.user.update_attribute(:score, @post.user.score+5)
        end
        @count = @post.reactions.shared.size
        @class = "share"
        render 'reactions/liked'
      when 'off-topic'
        @count = @post.reactions.offensive.size + @post.reactions.off_topic.size
        if @count >= 2
          @post.update_attribute(:status, 'flagged')
        end
        @class = "flag"
        render 'reactions/flagged'
      when 'offensive'
        @count = @post.reactions.offensive.size + @post.reactions.off_topic.size
        if @count >= 2
          @post.update_attribute(:status, 'flagged')
        end
        @class = "flag"
        render 'reactions/flagged'
    end
  end

  def flag_vote
    @vote = params[:vote]
    @id = params[:post_id]
    current_user.flag_votes.where(:post_id => params[:post_id]).destroy_all
    FlagVote.create(:vote => params[:vote], :post_id => params[:post_id], :user_id => current_user.id)
    render 'flag_voted'

  end

  private

  def post_params
    params.require(:post).permit(:body, :game_board_id, :user_id)
  end

end
