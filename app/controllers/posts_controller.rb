class PostsController < ApplicationController
  respond_to :js

  def show
    @item = Post.find_by_slug(params[:id])
    @comments = @item.comment_threads.order('created_at desc')
    @new_comment = Comment.build_from(@item, current_user.id, "") if user_signed_in?

  end

  def create
    if user_signed_in?
      @post = Post.create(post_params)
      current_user.posts << @post

      redirect_to post_path(@post.slug)
    end
  end


  def index
    @posts = Post.order(created_at: :desc)
    if params.has_key?(:tag)
      @posts=@posts.tagged_with(params[:tag])
    end
    if params.has_key?(:category)
      @posts=@posts.where(:category_id=>params[:category_id])
    end

    @total_pages = (@posts.length / 15) + 1

    posts = @posts.pluck(:id)
    if params.has_key?(:page)  && params[:page].to_i > 0
      offset = (params[:page].to_i-1) * 15
      ids = posts[offset..offset+14]
      @posts = Post.find(ids)
      render :partial => @posts
    else

      offset = 0
      ids = posts[offset..offset+14]
      @posts = Post.find(ids)
    end
  end


  def destroy
    @post = Post.find(params[:id])
    @id=@post.id
    if @post.destroy
      respond_with do |format|
        format.js {render 'destroy', :locals=>{id:@id}}
      end
    end
  end

  private

  def post_params
    params.require(:post).permit(:user_id, :resource_type, :category_id,:title,:body)
  end
end
