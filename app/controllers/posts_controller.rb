class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_topic, only: [ :index, :new, :create,  :show, :edit, :update, :destroy, :status,:rate]
  before_action :set_post , only: [ :show, :edit, :update, :destroy,:status,:rate]
  load_and_authorize_resource

  def index
    if params[:topic_id].nil?
      if params[:date_to].present? and params[:date_from].present?
        if params[:date_to] > params[:date_from]
          @posts =  pagination(Post.includes([:topic,:users]).eager_load([:comments,:ratings,:poly_rates]).content_filter(params[:date_from],params[:date_to]))
        end
      else
        @posts = pagination(Post.post_order).includes([:topic,:posts_users,:users]).eager_load([:ratings,:comments,:poly_rates])
      end
    else
      if params[:date_to].present? and params[:date_from].present?
        if params[:date_to] > params[:date_from]
          @posts =  pagination(@topic.posts.eager_load([:comments,:ratings,:poly_rates]).includes(:users).content_filter(params[:date_from],params[:date_to]))
        end
      else
        @posts = pagination(@topic.posts).eager_load([:ratings,:comments,:poly_rates]).includes([:posts_users,:users])
      end
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @post = @topic.posts.new
  end

  def rate
    @post.poly_rates.create(rating:params[:rating],user_id: current_user.id)
    respond_to do |format|
      format.html { redirect_to topic_post_path(@topic,@post), notice:'Post rated successfully.' }
      format.js
    end
  end

  def create
    @post = @topic.posts.new(post_params.merge(user_id: current_user.id))
    respond_to do |format|
      if @post.save
        format.html { redirect_to topic_posts_path(@topic), notice:'Post was successfully created.' }
        format.json { render :new, status: :created }
        format.js
      else
        flash.now[:error] = @post.errors.full_messages if @post.errors.any?
        format.js
        format.html { render :new, object: @tag }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @ratings = @post.ratings.rating_order
    @check_rating = check_rating_order(@ratings)
    @comments = @post.comments.eager_load(:user)
    @comment_rating = UserCommentRating.new
    @tag_relation = @post.tags
  end

  def destroy
    @post.destroy
    respond_to do |format|
      flash[:destroy] = 'Post was successfully destroyed.'
      format.html { redirect_to topic_posts_path }
      format.json { head :no_content }
    end
  end

  def edit
  end

  def update
    if @post.update_attributes(post_params.merge(user_id: current_user.id))
      flash[:notice] = 'Post was successfully updated.'
      redirect_to(topic_post_path(params[:topic_id],params[:id]))
    else
      render action: :edit
    end
  end

  def status
    respond_to do |format|
      unless @post.users.include?(current_user)
        @post.users << current_user
      end
      format.js
    end
  end

  private
  def set_topic
    if not params[:topic_id].blank?
      @topic = Topic.find(params[:topic_id])
      @tags = Tag.all
    end
  end

  def set_post
    @post = @topic.posts.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title,:body,:image, tag_ids: [],tags_attributes: [:tag])
  end

  def check_rating_order(ratings)
    rating_hash = { 1 => 0 , 2 => 0 , 3 => 0, 4=> 0, 5=> 0 }
    ratings.group_by{ |t| t.rating }.each do |key,collection|
      rating_hash[key] = collection.size
    end
    rating_hash
  end
end
