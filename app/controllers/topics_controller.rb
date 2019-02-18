class TopicsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_topic, only: [:show, :edit, :update, :destroy]
  # skip_before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @topics = pagination(Topic.all,per = 2)
  end

  def show
    @topic = Topic.find(params[:id])
    if current_user.nil? or not current_user.admin?
      @post = pagination(@topic.posts.includes(:posts_users).eager_load(:users).includes(:user))
    else
      @post = pagination(@topic.posts)
    end
    @new_post = Post.new
  end

  def new
    @topic = Topic.new
  end

  def edit
  end

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

  def destroy
    @topic.destroy
    respond_to do |format|
      flash[:destroy] = 'Topic was successfully destroyed.'
      format.html { redirect_to topics_url }
      format.json { render json: { message: 'record deleted' } }
    end
  end

  private
  def set_topic
    @topic = Topic.find(params[:id])
  end

  def topic_params
    params.require(:topic).permit(:name)
  end
end
