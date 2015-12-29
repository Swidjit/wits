class VotesController < ApplicationController

  def up
    vote = Vote.where(:vote=>"down",:voteable_id => params[:model_id], :voteable_type => params[:model_type], :user_id => current_user.id).first
    vote.destroy if vote
    vote = Vote.new(:vote=>"up",:voteable_id => params[:model_id], :voteable_type => params[:model_type], :user_id => current_user.id)
    if vote.save
      @up_count = Vote.where(:vote=>"up",:voteable_id => params[:model_id], :voteable_type => params[:model_type]).size
      @down_count = Vote.where(:vote=>"down",:voteable_id => params[:model_id], :voteable_type => params[:model_type]).size
      @id = params[:model_id]
      respond_to do |format|
        format.js {render 'success'}
      end
    else
      respond_to do |format|
        @notice = vote.errors.full_messages
        format.js {render 'failed'}
      end
    end
  end

  def down
    vote = Vote.where(:vote=>"up",:voteable_id => params[:model_id], :voteable_type => params[:model_type], :user_id => current_user.id).first
    vote.destroy if vote
    vote = Vote.new(:vote=>"down",:voteable_id => params[:model_id], :voteable_type => params[:model_type], :user_id => current_user.id)
    if vote.save
      @up_count = Vote.where(:vote=>"up",:voteable_id => params[:model_id], :voteable_type => params[:model_type]).size
      @down_count = Vote.where(:vote=>"down",:voteable_id => params[:model_id], :voteable_type => params[:model_type]).size
      @id = params[:model_id]
      respond_to do |format|
        format.js {render 'success'}
      end
    else
      respond_to do |format|
        @notice = vote.errors.full_messages
        format.js {render 'failed'}
      end
    end    
  end

end
