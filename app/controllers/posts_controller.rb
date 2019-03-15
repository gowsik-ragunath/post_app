class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_topic_and_tags
  before_action :set_post , only: [ :show, :edit, :update, :destroy, :status, :rate ]
  load_and_authorize_resource

  def index
    filter(params[:date_from],params[:date_to])
    @posts =  pagination(Post.includes([:topic,:users]).eager_load([:comments,:ratings,:poly_rates]).content_filter(@date_from,@date_to))
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @post = @topic.posts.new
  end

  def rate
    @check = @post.poly_rates.new(rating:params[:rating],user_id: current_user.id)
    if @check.save
      respond_to do |format|
        format.html { redirect_to topic_post_path(@topic,@post), notice:'Post rated successfully.' }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to topic_post_path(@topic,@post), notice:'Post was already rated.' }
        format.js
      end
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
    @ratings = @post.poly_rates.rating_order
    @check_rating = check_rating_order(@ratings)
    @comments = @post.comments.eager_load(:user)
    @comment_rating = UserCommentRating.new
    @tag_relation = @post.tags
  end

  def destroy
    respond_to do |format|
      if @post.destroy
        flash[:destroy] = 'Post was successfully destroyed.'
        format.html { redirect_to topic_posts_path }
        format.json { head :no_content }
      else
        flash[:destroy] = 'Post doesn\'t exist.'
        format.html { redirect_to topic_posts_path }
        format.json { head :not_found }
      end
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
  def set_topic_and_tags
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

  def filter(date_from ,date_to)
    unless date_from.present? and date_to.present?
      date_to = Time.now.strftime("%Y-%m-%d")
      date_from = "1990-01-01"
    end
    @date_from = DateTime.parse(date_from).beginning_of_day.strftime("%F %T")
    @date_to = Date.parse(date_to).end_of_day.strftime("%F %T")
  end
end
