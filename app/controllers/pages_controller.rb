class PagesController < ApplicationController

  def home
    #@best_of = Post.recent.find_with_reputation(:rating, :all, {:order => "rating desc"})
    @best_of = Post.all
    @current_games = GameBoard.active
    if user_signed_in?
      @recent_games = GameBoard.expired.joins(:posts).where('posts.user_id' => current_user.id).order('created_at DESC').limit(3)
    end
  end

  def index
    render params[:page_name]
  end



  def sitemap

  end

end
