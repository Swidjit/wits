class ConversationsController < ApplicationController
  #before_filter :authenticate_user!
  before_filter :load_resource, :only => :destroy
  #authorize_resource :only => :destroy

  def create
    if params[:item_id]
      #recipient_id = Item.find(item_id_from_slug(params[:item_id])).user.id
      #conversation = Conversation.create(:item_id => item_id_from_slug(params[:item_id]), :user => current_user, :recipient_id => recipient_id)
      #Message.create(:conversation_id => conversation.id, :user => current_user, :body => params[:text])

    else
      conversation = Conversation.where(:user_id => current_user.id, :recipient_id => params[:user_id]).first
      if conversation.blank?
        conversation = Conversation.where(:user_id => params[:user_id], :recipient_id => current_user.id).first
        if conversation.blank?
          conversation = Conversation.create(:user => current_user, :recipient_id => params[:user_id])
        end
      end


      message = Message.create(:conversation_id => conversation.id, :user => current_user, :body => params[:text])
    end


    flash[:notice] = "message sent"
    redirect_to :back
  end

  def index
    # nested within items
    if params[:item_id].present?
      load_and_authorize_conversation
      render :partial => 'conversation', :layout => false

    # nested within users
    else
      load_all_conversations_for_current_user
      puts "loading"
    end
    if params[:conversation_id].present?
      @loaded_conversation = Conversation.find(params[:conversation_id]).includes(:messages, :item, :user)
    else
      @loaded_conversation = @conversations.first
    end

  end

  def show
    @conversation = Conversation.find(params[:id])
    respond_to do |format|
      format.js {render 'show', :locals => {conversation: @conversation}}
    end
  end
  
  def broadcast
    if current_user.is_admin?

    else
      redirect_to :home
    end
  end
  
  def send_broadcast
    if current_user.is_admin?
      conversation = Conversation.create(:user => current_user, :recipient_id => "-1")
      Message.create(:conversation_id => conversation.id, :user => current_user, :body => params[:text])
      flash[:notice] = "message sent"
      redirect_to :back
    else
      redirect_to :home
    end
  end

  def destroy
    @conversation.destroy
    redirect_to :back
  end
=begin  
  def search
    load_all_conversations_for_current_user
    messages = @conversations.map{|m| m.id}
    message_search = Message.search do
      fulltext params[:term]
      with :conversation_id, messages
    end
    results = message_search.results.first(10)
    unless results.nil?
      respond_to do |format|
        format.json { render :json => results.collect{|r| {:id => r.id,:value => r.search_excerpt(params[:term]), :path => conversation_path(r.conversation_id)}} }
      end
    end
  end
=end  
  

private

  def load_resource
    @conversation = Conversation.find(params[:id])
  end

  def load_and_authorize_conversation
    user_id = params[:user_id] || current_user.id
    @conversation = Conversation.find(:user_id => user_id)

    #authorize! :read, @conversation
  end

  def load_all_conversations_for_current_user
    user_id = current_user.id
    @conversations = (Conversation.includes(:messages).from_user(current_user) + Conversation.includes(:messages).for_user(current_user) + Conversation.includes(:messages).where(:recipient_id => "-1")).sort{|a,b| b.messages.first.created_at <=> a.messages.first.created_at }
    #@conversations = (Conversation.includes(:messages, :item).for_user_message(current_user) + Conversation.includes(:messages, :item).from_user(current_user) + Conversation.includes(:messages, :item).for_user(current_user) + Conversation.includes(:messages, :item).where(:recipient_id => "-1")).sort{|a,b| b.messages.first.created_at <=> a.messages.first.created_at }
    @conversations = @conversations.uniq
    #at some point we want to be sorting these on the date of the most recent child messare
  end
end
