class TopicsController < ApplicationController
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format =~ %r{application/json} }
  before_action :set_topic, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!
  load_and_authorize_resource

  # GET /topics
  # GET /topics.json
  def index
    @topics = Topic.paginate(page: params[:page], per_page: 2)
  end

  # GET /topics/1
  # GET /topics/1.json
  def show
    @topic = Topic.find(params[:id])
    if current_user.nil? or not current_user.admin?
      @post = @topic.posts.paginate(page: params[:page], per_page: 10).includes(:user)
    else
      @post = @topic.posts.paginate(page: params[:page], per_page: 10)
    end
      @new_post = Post.new
  end

  # GET /topics/new
  def new
    @topic = Topic.new
  end

  # GET /topics/1/edit
  def edit
  end

  # POST /topics
  # POST /topics.json
  def create
    @topic = Topic.new(topic_params)
    respond_to do |format|
      if @topic.save
        format.html { redirect_to topics_path, notice: 'Topic was successfully created.' }
        format.json { render json:  @topic.as_json(except: [:created_at, :updated_at]) }
      else
        format.html { render :new }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /topics/1
  # PATCH/PUT /topics/1.json
  def update
    respond_to do |format|
      if @topic.update(topic_params)
        format.html { redirect_to @topic, notice: 'Topic was successfully updated.' }
        format.json { render :show, status: :ok, location: @topic }
      else
        format.html { render :edit }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.json
  def destroy
    @topic.destroy
    respond_to do |format|
      flash[:destroy] = 'Topic was successfully destroyed.'
      format.html { redirect_to topics_url }
      format.json { render json: { message: 'record deleted' } }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_topic
      @topic = Topic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def topic_params
      params.require(:topic).permit(:name)
    end
end
