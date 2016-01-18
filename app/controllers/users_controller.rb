class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy,:finish_signup]
  before_filter :ensure_signup_complete, only: [:new, :create, :update, :destroy]
  respond_to :js

  def show
    @user = User.where(:username=>params[:display_name]).first

    #entries by user
    if current_user == @user
      @posts = Post.unscoped.where(:user_id => @user.id).order("created_at DESC")
    else
      if user_signed_in?
        @subscription = current_user.subscriptions.where(:subscription_id => @user.id).first
      end
      @posts = @user.posts
    end
    ids = @user.awards.winner.pluck(:id)
    ids.concat @user.awards.top10.pluck(:id)
    ids.concat @user.awards.top10pct.pluck(:id)
    result_hash = Award.find(ids).each_with_object({}) {|result,result_hash| result_hash[result.id] = result }
    result_hash=ids.map {|id| result_hash[id]}

    @awards = result_hash
    #entries loved by user
    ids = @user.reactions.shared.map(&:post_id)
    puts ids
    @fav_posts = Post.find(ids)

    @stats = @user.game_stats.order(pct: :desc)

    @subscribers = @user.subscribed_users
  end

  def edit
    @user = User.find_by_username(params[:id])
  end

  def index
    @users = User.all
    user_hash = Subscription.where('subscription_type=?','user').group('subscription_id').order('count_subscription_id desc').count('subscription_id')
    user_ids = user_hash.keys.sort {|a, b| user_hash[b] <=> user_hash[a]}
    @popular_users = User.where('id in (?)',user_ids)
    if user_signed_in?
      ids = current_user.subscriptions.where(:subscription_type => "user").map(&:subscription_id)
      puts "jey"
      puts ids
      @user_subscriptions = User.where("id IN (?)", ids)
    end
  end


  def search
    @users = User.find(:all, :conditions => ['name ILIKE ? or first_name ILIKE ? or last_name ILIKE ?', "%#{params[:name]}%","%#{params[:name]}%","%#{params[:name]}%"])
    render file: 'users/search.json.rabl'
  end

  def notifications
    @notifications = current_user.notifications.includes(:sender,:notifier).reverse_order
    @notifications.each do |n|
      n.read = true
      n.save!
    end
  end

  def update
    # authorize! :update, @user
    respond_to do |format|
      if @user.update(user_params)
        sign_in(@user == current_user ? @user : current_user, :bypass => true)
        format.html { redirect_to profile_path(@user.username), notice: 'Your profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET/PATCH /users/:id/finish_signup
  def finish_signup
    # authorize! :update, @user
    if request.patch? && params[:user] #&& params[:user][:email]
      if @user.update(user_params)

        sign_in(@user, :bypass => true)
        redirect_to root_path, notice: 'Your profile was successfully updated.'
      else
        @show_errors = true
      end

    else

    end
  end

  # DELETE /users/:id.:format
  def destroy
    # authorize! :delete, @user
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

  def autocomplete
    @users = User.where("username LIKE (?) or first_name LIKE (?)","%#{params[:q]}%","%#{params[:q]}%")
    render file: 'users/search.json.rabl'
  end

  def upload_file
    current_user.update_attribute(:avatar, URI.parse(URI.unescape(params['url'])))
    @user = User.find(params[:id])
  end


  private

  def set_user
    @user = User.find_by_username(params[:id])
  end

  def user_params
    params.require(:user).permit([:username, :first_name, :last_name, :email, :address, :about, :avatar, :dietary_list,:password, :password_confirmation])
  end

end
