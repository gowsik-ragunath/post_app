class TopicsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate, if: Proc.new { |c| c.request.format.json? }
  before_action :set_topic, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def index
    @topics = pagination(Topic.all,per = 2)
  end

  def show
    @post = pagination(@topic.posts.eager_load(:users,:user))
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
        args = { user_id: current_user.id, topic_name: @topic.name }
        # SendEmailJob.set(wait: 2.seconds).perform_later(args)
        EmailWorker.perform_in(5.seconds,args)
        # TopicMailer.send_topic_created(args).deliver_now
        format.html { redirect_to topics_path, notice: 'Topic was successfully created.' }
        format.json { render :show, status: :created, location: @topic  }
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
    respond_to do |format|
      if @topic.destroy
        flash[:destroy] = 'Topic was successfully destroyed.'
        format.html { redirect_to topics_url }
        format.json { render json: { message: 'record deleted' } }
      else
        flash[:destroy] = 'Topic was not destroyed.'
        format.html { redirect_to topics_url }
        format.json { render json: { message: 'record deleted' } }
      end
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
