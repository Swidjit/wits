class MessagesController < ApplicationController
  def create
    @message = Message.create!(:user => current_user, :body => params[:conversation_message][:body], :conversation_id => params[:conversation_message][:conversation_id])
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end
end
