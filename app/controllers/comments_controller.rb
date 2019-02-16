class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_topic, only: [ :new, :create, :show, :edit, :update, :destroy]
  before_action :set_post, only: [ :new, :create, :show, :edit, :update, :destroy]
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def index
    @comments = Post.find(params[:post_id]).comments.includes(:user)
  end

  def new
    @comment = @post.comments.new
  end

  def edit
  end

  def create
    @comment = @post.comments.new(comment_params.merge(user_id: current_user.id))
    @comment.commenter = current_user.email
    respond_to do |format|
      if @comment.save
        flash[:success] = 'Comment was successfully created.'
        format.html { redirect_to topic_post_path(params[:topic_id],params[:post_id]) }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @comment.post_id = params[:post_id]
    @comment.commenter = current_user.email
    respond_to do |format|
      if @comment.update(comment_params.merge(user_id: current_user.id))
        flash[:success] = 'Comment was successfully updated.'
        format.html { redirect_to topic_post_path(params[:topic_id],params[:post_id]) }
        format.json { render :show, status: :ok, location: topic_post_comments_path(params[:topic_id],params[:post_id]||params[:id]) }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      flash[:destroy] = 'Comment was successfully destroyed.'
      format.html { redirect_to topic_post_path(params[:topic_id],params[:post_id]) }
      format.json { head :no_content }
    end
  end

  def rate
    if current_user
########polymorphic association#######################
      value = @comment.poly_rates.create(rating: params[:rating],user_id: current_user.id)
      if value.errors
        @error = value.errors.messages[:user_id][0]
      end
########join table association########################
      # begin
      #   comment_rating = Rating.new(rating:params[:rating])
      #   verify = UserCommentRating.new(user_id: current_user.id,comment_id: params[:id])
      #   comment_rating.transaction do
      #     comment_rating.save!
      #     verify.rating_id = comment_rating.id
      #     verify.save!
      #   end
      # rescue ActiveRecord::RecordInvalid => exception
      #   @error = exception
      # end
    end
    respond_to do |format|
      format.js
      format.html { redirect_to topic_post_path(params[:topic_id],params[:id]) }
    end
  end

  def show
    # @check =  UserCommentRating.where(comment_id: params[:id]).eager_load(:user)
    @check = @comment.poly_rates
    respond_to do |format|
      format.js
      format.html { redirect_to topic_post_path(params[:topic_id],params[:id])}
    end
  end

  private
  def set_topic
    @topic = Topic.find(params[:topic_id])
  end

  def set_post
    @post = @topic.posts.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
