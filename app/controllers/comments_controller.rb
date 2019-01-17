class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  # GET /comments
  # GET /comments.json
  def index
    # @post = Post.where(topic_id: params[:topic_id])
    @comments = Comment.where(post_id: params[:post_id])
    # @post.each do |p|
    #   @comments.push(Comment.find_by(post_id: p.id))
    # end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit

    print @comment.methods
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)
    @comment.post_id = params[:post_id]
    respond_to do |format|
      if @comment.save
        format.html { redirect_to topic_post_path(params[:topic_id],params[:post_id]), notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: topic_post_comment_path(1,1,@comment) }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
    @comment.post_id = params[:post_id]
      if @comment.update(comment_params)
        format.html { redirect_to topic_post_comment_path(params[:topic_id],params[:post_id],@comment), notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: topic_post_comment_path(params[:topic_id],params[:post_id],@comment) }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to topic_post_comments_path(params[:topic_id],params[:post_id]), notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
        @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.permit(:commenter, :body)
    end
end
