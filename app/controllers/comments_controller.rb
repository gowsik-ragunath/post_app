class CommentsController < ApplicationController
  before_action :set_post, only: [ :new, :create, :show, :edit, :update, :destroy]
  before_action :set_comment, only: [:show, :edit, :update, :destroy]


  def index
    @comments = Post.find(params[:post_id]).comments
  end

  def new
    @comment = @post.comments.new
  end


  def edit
  end

  def create
    @comment = @post.comments.new(comment_params)
    
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

    respond_to do |format|
      if @comment.update(comment_params)
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
        @topic = Topic.find(params[:topic_id])
        @post = @topic.posts.find(params[:post_id])
    end
    def set_comment

        @comment = @post.comments.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:commenter, :body)
    end
end
