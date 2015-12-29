class SubscriptionsController < ApplicationController
  # authorize_resource :only => :destroy
  before_filter :load_resource, :only => :destroy
  before_filter :authenticate_user!, :only => [:create, :destroy]
  


  def index
 
    @subscriptions = current_user.subscriptions
    @page_title = "Your subscriptions list"
    user_ids = @subscriptions.map(&:subscription_id)
    @posts = Post.where('user_id in (?)',user_ids)
  end

  def create
    if params[:user_id].present?
      @user = User.find(params[:user_id])
      @subscription = Subscription.new(:subscription_id => params[:user_id],:subscription_type => "user", :user => User.find(current_user.id))
      if @subscription.save
        #current_user.subscriptions << @subscription
        respond_to do |format|
          format.js 
        end
      else
        respond_to do |format|
          format.json { render json: {error:{msg:"you have already added that tag as an subscription"}}, status: :unprocessable_entity }
        end 
      end      
    end
  end


  def destroy
    @counter=@subscription.id
    @subscription.destroy
    @user = User.find(params[:user_id])
    respond_to do |format|
      format.js {}
    end
  end


  private
  def load_resource
    @subscription = Subscription.find(params[:id])
  end
end
