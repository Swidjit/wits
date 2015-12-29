class BoardSuggestionsController < ApplicationController
  def create
    @suggestion = BoardSuggestion.new(:suggestion => params[:board_suggestion][:suggestion], :game_id =>  params[:board_suggestion][:game_id], :user_id => current_user.id)
    if @suggestion.save
      @notice = "thanks for the suggestion"
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.js {render 'failed'}
      end
    end
  end
  
  def show
    @game = Game.find(params[:game])
    @suggestions = BoardSuggestion.where(:game_id => params[:game])
  end
end
