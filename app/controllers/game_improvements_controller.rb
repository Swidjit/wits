class GameImprovementsController < ApplicationController
  def create
    @improvement = GameImprovement.new(:improvement => params[:game_improvement][:improvement], :game_id =>  params[:game_improvement][:game_id], :user_id => current_user.id)
    if @improvement.save
      @notice = "thanks for the improvement"
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.js {render 'failed'}
      end
    end
  end
  def destroy
    @improvement = GameImprovement.find(params[:id])
    if @improvement.destroy
      @notice = "improvement has been deleted"
      @id = params[:id]
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.js {render 'failed'}
      end
    end
  end
  

end
